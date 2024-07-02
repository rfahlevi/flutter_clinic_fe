import 'package:flutter/material.dart';
import 'package:flutter_clinic/domain/entities/medical_record.dart';

import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';
import '../../../misc/spacing.dart';

List<Widget> diagnoseAndMedicalTreatment({
  required BuildContext context,
  required MedicalRecord medicalRecord,
  required ThemeData? theme,
}) =>
    [
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
          'Diagnosa & Penanganan',
          style: ClinicTextStyle.h4SemiBold().copyWith(
            color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.black,
          ),
        ),
      ),
      verticalSpace(14),
      Row(
        children: [
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Diagnosa',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  medicalRecord.diagnosis,
                  style: ClinicTextStyle.h4Regular(),
                )
              ],
            ),
          ),
          horizontalSpaces(14),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Medical Treatment',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  medicalRecord.medicalTreatment,
                  style: ClinicTextStyle.h4Regular(),
                )
              ],
            ),
          )
        ],
      ),
      verticalSpace(14),
    ];
