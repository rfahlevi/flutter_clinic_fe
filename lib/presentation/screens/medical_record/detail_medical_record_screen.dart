// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/domain/entities/user.dart';
import 'package:flutter_clinic/presentation/blocs/theme/toggle_theme_bloc/toggle_theme_bloc.dart';

import 'package:flutter_clinic/presentation/extension/clinic_loading.dart';
import 'package:flutter_clinic/presentation/misc/clinic_color.dart';
import 'package:flutter_clinic/presentation/misc/clinic_textstyle.dart';
import 'package:flutter_clinic/presentation/misc/spacing.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/diagnose_and_medical_treatment.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/doctor_notes.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/handled_by.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/medical_service_of_patient.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/select_payment_method_modal.dart';
import 'package:flutter_clinic/presentation/widgets/empty_data.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/get_user/get_user_bloc.dart';
import '../../blocs/medical_record/get_mr_by_reservation_id_bloc/get_mr_by_reservation_id_bloc.dart';
import '../transaction/checkout_transaction_screen.dart';

class DetailMedicalRecordScreen extends StatefulWidget {
  static const routerName = 'detail-medical-record';
  final String reservationId;
  const DetailMedicalRecordScreen({
    super.key,
    required this.reservationId,
  });

  @override
  State<DetailMedicalRecordScreen> createState() => _DetailMedicalRecordScreenState();
}

class _DetailMedicalRecordScreenState extends State<DetailMedicalRecordScreen> {
  @override
  void initState() {
    context.read<GetMrByReservationIdBloc>().add(
          GetMrByReservationIdEvent.doGet(
            reservationId: int.parse(widget.reservationId),
          ),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<GetUserBloc>().state.whenOrNull(success: (user) => user);
    ThemeData? theme = context.watch<ToggleThemeBloc>().state.whenOrNull(themeResult: (themeResult) => themeResult);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: ClinicColor.primary,
        foregroundColor: ClinicColor.white,
        title: Text(
          'Detail Medical Record',
          style: ClinicTextStyle.h3SemiBold(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: BlocBuilder<GetMrByReservationIdBloc, GetMrByReservationIdState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => ClinicLoading.shimmer(context),
              failed: (message) => EmptyData(
                message: message,
                onPressed: () {
                  context.read<GetMrByReservationIdBloc>().add(
                        GetMrByReservationIdEvent.doGet(
                          reservationId: int.parse(
                            widget.reservationId,
                          ),
                        ),
                      );
                },
              ),
              success: (medicalRecord) {
                return ListView(
                  children: [
                    ...handledBy(
                      context: context,
                      patientReservation: medicalRecord.patientReservation,
                      theme: theme,
                    ),
                    ...diagnoseAndMedicalTreatment(
                      context: context,
                      medicalRecord: medicalRecord,
                      theme: theme,
                    ),
                    ...doctorNotes(
                      context: context,
                      medicalRecord: medicalRecord,
                    ),
                    ...medicalServiceOfPatient(
                      context: context,
                      medicalRecord: medicalRecord,
                      theme: theme,
                    ),
                    verticalSpace(40),
                    if (medicalRecord.patientReservation.status != 'Selesai' && user?.role == 'dokter')
                      Center(
                        child: Text(
                          'Silahkan lakukan pembayaran di kasir',
                          style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.danger),
                        ),
                      ),

                    if (medicalRecord.patientReservation.status != 'Selesai' && user?.role != 'dokter')
                      ElevatedButton(
                        onPressed: () => selectPaymentMethodModal(
                          context: context,
                          grossAmount: medicalRecord.patientReservation.totalPrice!,
                          medicalRecord: medicalRecord,
                          onTapQRIS: () {
                            context.pop();
                            context.pushNamed(
                              CheckoutTransactionScreen.routerName,
                              extra: medicalRecord,
                              queryParameters: {
                                'paymentMethod': 'QRIS',
                              },
                            );
                          },
                          onTapTunai: () {
                            context.pop();
                            context.pushNamed(
                              CheckoutTransactionScreen.routerName,
                              extra: medicalRecord,
                              queryParameters: {
                                'paymentMethod': 'Tunai',
                              },
                            );
                          },
                        ),
                        child: const Text('Proses Pembayaran'),
                      ),
                    if (medicalRecord.patientReservation.status == 'Selesai')
                      Center(
                        child: Text(
                          'Transaksi sudah selesai',
                          style: ClinicTextStyle.h4Medium().copyWith(color: ClinicColor.success),
                        ),
                      ),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Theme.of(context).colorScheme.surface,
                    //     side: BorderSide(color: ClinicColor.primary),
                    //   ),
                    //   child: Text(
                    //     'Detail Pembayaran',
                    //     style: ClinicTextStyle.h4SemiBold().copyWith(
                    //       color: ClinicColor.primary,
                    //     ),
                    //   ),
                    // ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
