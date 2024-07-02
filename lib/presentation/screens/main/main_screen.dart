// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/data/datasources/satu_sehat/satu_sehat_local_datasource.dart';
import 'package:flutter_clinic/data/datasources/theme/theme_local_datasource.dart';
import 'package:flutter_clinic/domain/entities/patient.dart';
import 'package:flutter_clinic/domain/entities/patient_reservation.dart';
import 'package:flutter_clinic/domain/entities/user.dart';
import 'package:flutter_clinic/presentation/blocs/auth/get_user/get_user_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/master/patient/get_patients_bloc/get_patients_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/patient_reservation/get_patient_reservations_bloc/get_patient_reservations_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/satu_sehat/ss_get_token_bloc/ss_get_token_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/theme/toggle_theme_bloc/toggle_theme_bloc.dart';
import 'package:flutter_clinic/presentation/extension/clinic_loading.dart';
import 'package:flutter_clinic/presentation/extension/datetime_formatter.dart';
import 'package:flutter_clinic/presentation/misc/clinic_textstyle.dart';
import 'package:flutter_clinic/presentation/misc/clinic_theme.dart';
import 'package:flutter_clinic/presentation/misc/spacing.dart';
import 'package:flutter_clinic/presentation/screens/login/login_screen.dart';
import 'package:flutter_clinic/presentation/screens/main/methods/clinic_information.dart';
import 'package:flutter_clinic/presentation/screens/main/methods/main_header.dart';
import 'package:flutter_clinic/presentation/screens/main/methods/menu.dart';
import 'package:flutter_clinic/presentation/screens/patient_reservation/patient_reservation_service.dart';
import 'package:flutter_clinic/presentation/widgets/patient_reservation_card.dart';
import 'package:go_router/go_router.dart';

import '../../extension/clinic_alert.dart';
import '../../misc/clinic_color.dart';

class MainScreen extends StatefulWidget {
  static const routerName = '/main';
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isDark = false;
  @override
  void initState() {
    setState(() {
      Future.delayed(const Duration(seconds: 0), () async {
        isDark = await ThemeLocalDatasource().getToggle();
        context
            .read<ToggleThemeBloc>()
            .add(ToggleThemeEvent.toggle(themeRequest: isDark ? ClinicTheme.darkTheme() : ClinicTheme.lightTheme()));

        context.read<GetPatientReservationsBloc>().add(const GetPatientReservationsEvent.doGet(patient: ''));
        context.read<GetPatientsBloc>().add(const GetPatientsEvent.getFirst(patient: ''));

        // Get Satu Sehat Token
        String? satuSehatToken = await SatuSehatLocalDatasource().getToken();

        if (satuSehatToken == null) {
          context.read<SsGetTokenBloc>().add(const SsGetTokenEvent.doGet());
        } else {
          await SatuSehatLocalDatasource().removeToken().then((value) {
            context.read<SsGetTokenBloc>().add(const SsGetTokenEvent.doGet());
          });
        }
      });
    });
    context.read<GetUserBloc>().add(const GetUserEvent.doGet());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

    User? user = context.watch<GetUserBloc>().state.whenOrNull(success: (user) => user);
    List<Patient> patients =
        context.watch<GetPatientsBloc>().state.whenOrNull(success: (patients, isNext) => patients) ?? [];
    List<PatientReservation> patientReservations = context
            .watch<GetPatientReservationsBloc>()
            .state
            .whenOrNull(success: (patientReservations) => patientReservations) ??
        [];

    return BlocListener<GetUserBloc, GetUserState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          failed: (message) {
            ClinicAlert.error(context: context, content: message);
            context.goNamed(LoginScreen.routerName);
          },
        );
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: RefreshIndicator(
              key: refreshIndicatorKey,
              backgroundColor: ClinicColor.white,
              color: ClinicColor.primary,
              strokeWidth: 3,
              onRefresh: () async {
                await Future.delayed(
                  const Duration(seconds: 0),
                  () {
                    context
                        .read<GetPatientReservationsBloc>()
                        .add(const GetPatientReservationsEvent.doGet(patient: ''));
                    context.read<GetPatientsBloc>().add(const GetPatientsEvent.getFirst(patient: ''));
                  },
                );
              },
              child: ListView(
                children: [
                  ...mainHeader(
                    context: context,
                    isDark: isDark,
                    onChanged: (value) {
                      setState(() {
                        isDark = value;
                        Future.delayed(
                          const Duration(seconds: 0),
                          () async {
                            await ThemeLocalDatasource().saveToggle(isDark);
                          },
                        );
                        context.read<ToggleThemeBloc>().add(ToggleThemeEvent.toggle(
                            themeRequest: isDark ? ClinicTheme.darkTheme() : ClinicTheme.lightTheme()));
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Selamat Datang, ${user?.name}',
                        style: ClinicTextStyle.h4SemiBold(),
                      ),
                      Text(
                        'Login Sebagai : ${user?.role.substring(1).replaceRange(0, 0, user.role[0].toUpperCase())}',
                        style: ClinicTextStyle.h5Regular(),
                      ),
                    ],
                  ),
                  verticalSpace(14),
                  clinicInformation(
                    patients: patients,
                    patientReservations: patientReservations,
                  ),
                  ...menu(
                    context: context,
                    user: user,
                  ),
                  Text(
                    'Pasien Hari Ini',
                    style: ClinicTextStyle.h4SemiBold().copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  verticalSpace(14),
                  BlocBuilder<GetPatientReservationsBloc, GetPatientReservationsState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        orElse: () => ClinicLoading.shimmer(context),
                        failed: (message) => Text(message, style: ClinicTextStyle.h4Regular()),
                        success: (patientReservations) {
                          List<PatientReservation> reservations = patientReservations
                              .where((element) =>
                                  DateTimeFormatter.dMMMMyyy(element.scheduleTime) ==
                                  DateTimeFormatter.dMMMMyyy(DateTime.now().toString()))
                              .toList();

                          if (reservations.isEmpty) {
                            return Text(
                              'Belum ada pasien hari ini',
                              style: ClinicTextStyle.h4Regular(),
                            );
                          } else {
                            return Column(
                              children: reservations
                                  .map((e) => PatientReservationCard(
                                      patientReservation: e,
                                      statusColor: PatientReservationService.statusColor(e.status)))
                                  .toList(),
                            );
                          }
                        },
                      );
                    },
                  ),
                  verticalSpace(7),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
