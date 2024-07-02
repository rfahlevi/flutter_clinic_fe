import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/domain/entities/clinic_service.dart';
import 'package:flutter_clinic/domain/entities/patient_reservation.dart';
import 'package:flutter_clinic/domain/entities/user.dart';
import 'package:flutter_clinic/presentation/extension/rupiah_formatter.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/select_clinic_services_screen.dart';
import 'package:flutter_clinic/presentation/widgets/selected_clinic_service_card.dart';
import 'package:go_router/go_router.dart';

import '../../../blocs/master/clinic_service/get_clinic_services_bloc/get_clinic_services_bloc.dart';
import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';
import '../../../misc/spacing.dart';

List<Widget> medicalService({
  required BuildContext context,
  required PatientReservation patientReservation,
  required TextEditingController searchC,
  required bool hasSelectedService,
  required int totalAmount,
  required User? user,
  required ThemeData? theme,
}) =>
    [
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: patientReservation.status == 'Batal'
              ? ClinicColor.danger.withOpacity(.2)
              : ClinicColor.warning.withOpacity(.2),
        ),
        child: Text(
          'Medical Service',
          style: ClinicTextStyle.h4SemiBold().copyWith(
            color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.black,
          ),
        ),
      ),
      verticalSpace(14),
      if (hasSelectedService)
        BlocBuilder<GetClinicServicesBloc, GetClinicServicesState>(
          builder: (context, state) {
            return state.maybeWhen(
              orElse: () => const SizedBox(),
              success: (clinicServices) {
                List<ClinicService> data = clinicServices.where((element) => element.isChecked == true).toList();
                totalAmount = data.fold(0, (previousValue, element) => previousValue + element.subtotal);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return SelectedClinicServiceCard(
                          clinicService: data[index],
                          index: index,
                        );
                      },
                    ),
                    if (data.isNotEmpty) Divider(color: ClinicColor.border),
                    if (data.isNotEmpty)
                      Text(
                        'Total : ${rupiahFormatter('$totalAmount')}',
                        style: ClinicTextStyle.h3Bold().copyWith(
                          color: theme?.colorScheme.surface == ClinicColor.darkBg
                              ? ClinicColor.warning
                              : ClinicColor.primary,
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Tampilkan jika tidak ada layanan yang dipilih
          if (!hasSelectedService)
            Text(
              'Belum memilih layanan',
              style: ClinicTextStyle.h4Regular(),
            ),
          horizontalSpaces(24),
          if (patientReservation.status == 'Menunggu' && user != null && user.role != 'user')
            SizedBox(
              width: 160,
              height: 40,
              child: TextButton(
                onPressed: () {
                  context.pushNamed(SelectClinicServicesScreen.routerName);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pilih Layanan',
                      style: ClinicTextStyle.h5SemiBold().copyWith(
                          color: theme?.colorScheme.surface == ClinicColor.darkBg
                              ? ClinicColor.warning
                              : ClinicColor.primary),
                    ),
                    horizontalSpaces(7),
                    Icon(
                      CupertinoIcons.arrow_right_square_fill,
                      size: 20,
                      color:
                          theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.warning : ClinicColor.primary,
                    )
                  ],
                ),
              ),
            )
        ],
      ),
      verticalSpace(40),
    ];
