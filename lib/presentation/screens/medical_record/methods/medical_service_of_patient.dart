import 'package:flutter/material.dart';
import 'package:flutter_clinic/domain/entities/medical_record.dart';
import 'package:flutter_clinic/presentation/misc/spacing.dart';

import '../../../extension/rupiah_formatter.dart';
import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';

List<Widget> medicalServiceOfPatient({
  required BuildContext context,
  required MedicalRecord medicalRecord,
  required ThemeData? theme,
}) {
  int totalAmount = medicalRecord.medicalRecordServices.isEmpty
      ? 0
      : medicalRecord.medicalRecordServices.fold(
          0,
          (previousValue, element) => previousValue + element.clinicService.subtotal,
        );

  return [
    Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: medicalRecord.patientReservation.status == 'Batal'
            ? ClinicColor.danger.withOpacity(.2)
            : medicalRecord.patientReservation.status == 'Proses'
                ? ClinicColor.primary.withOpacity(.2)
                : medicalRecord.patientReservation.status == 'Selesai'
                    ? ClinicColor.success.withOpacity(.2)
                    : ClinicColor.warning.withOpacity(.2),
      ),
      child: Text(
        'Layanan Klinik',
        style: ClinicTextStyle.h4SemiBold().copyWith(
          color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.black,
        ),
      ),
    ),
    verticalSpace(14),
    if (medicalRecord.medicalRecordServices.isNotEmpty)
      ListView.builder(
        itemCount: medicalRecord.medicalRecordServices.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                minVerticalPadding: 7,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kategori : ${medicalRecord.medicalRecordServices[index].clinicService.category}',
                      style: ClinicTextStyle.h5Regular().copyWith(
                          color:
                              theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.grey),
                    ),
                    Text(
                      medicalRecord.medicalRecordServices[index].clinicService.name,
                      style: ClinicTextStyle.h4SemiBold(),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Harga Satuan : ${rupiahFormatter(
                        medicalRecord.medicalRecordServices[index].clinicService.price.toString(),
                      )}',
                      style: ClinicTextStyle.h5Regular(),
                    ),
                    Text(
                      'Subtotal : ${rupiahFormatter(
                        medicalRecord.medicalRecordServices[index].clinicService.subtotal.toString(),
                      )}',
                      style: ClinicTextStyle.h5Medium().copyWith(
                        color: theme?.colorScheme.surface == ClinicColor.darkBg
                            ? ClinicColor.warning
                            : ClinicColor.primary,
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  'x${medicalRecord.medicalRecordServices[index].qty}',
                  style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.primary),
                ),
              ),
              Divider(color: ClinicColor.border),
            ],
          );
        },
      ),
    if (medicalRecord.medicalRecordServices.isNotEmpty)
      Text('Total : ${rupiahFormatter(totalAmount.toString())}',
          style: ClinicTextStyle.h3Bold().copyWith(
              color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.warning : ClinicColor.primary)),
  ];
}
