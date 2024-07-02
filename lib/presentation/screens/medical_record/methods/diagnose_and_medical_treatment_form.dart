import 'package:flutter/material.dart';
import 'package:flutter_clinic/domain/entities/patient_reservation.dart';
import 'package:flutter_clinic/domain/entities/user.dart';

import '../../../extension/clinic_form.dart';
import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';
import '../../../misc/spacing.dart';

List<Widget> diagnoseAndMedicalTreatmentForm({
  required BuildContext context,
  required PatientReservation patientReservation,
  required TextEditingController diagnoseC,
  required TextEditingController medicalTreatmentC,
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
            child: ClinicForm(
              readOnly: patientReservation.status == 'Batal' || user != null && user.role == 'user',
              controller: diagnoseC,
              label: 'Diagnosa',
              hintText: 'Diagnosa Penyakit',
              minLines: 3,
              maxLines: 5,
            ),
          ),
          horizontalSpaces(14),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: ClinicForm(
              readOnly: patientReservation.status == 'Batal' || user != null && user.role == 'user',
              controller: medicalTreatmentC,
              label: 'Medical Treatment',
              hintText: 'Medical treatment',
              minLines: 3,
              maxLines: 5,
            ),
          )
        ],
      ),
      verticalSpace(14),
    ];
