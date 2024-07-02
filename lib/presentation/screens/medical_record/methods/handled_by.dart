import 'package:flutter/material.dart';
import 'package:flutter_clinic/domain/entities/patient_reservation.dart';

import '../../../extension/datetime_formatter.dart';
import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';
import '../../../misc/spacing.dart';

List<Widget> handledBy({
  required BuildContext context,
  required PatientReservation patientReservation,
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
              : patientReservation.status == 'Proses'
                  ? ClinicColor.primary.withOpacity(.2)
                  : patientReservation.status == 'Selesai'
                      ? ClinicColor.success.withOpacity(.2)
                      : ClinicColor.warning.withOpacity(.2),
        ),
        child: Text('Ditangani Oleh',
            style: ClinicTextStyle.h4SemiBold().copyWith(
                color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.black)),
      ),
      verticalSpace(14),
      Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 100,
              height: 100,
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/img_placeholder.png'),
                image: patientReservation.doctor.photo != null && patientReservation.doctor.photo!.contains('https')
                    ? NetworkImage(patientReservation.doctor.photo!)
                    : NetworkImage(
                        'http://www.laravel-clinic-be.test/storage/doctors/${patientReservation.doctor.photo}'),
                imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/images/img_placeholder.png'),
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 250),
                fadeOutDuration: const Duration(
                  milliseconds: 250,
                ),
              ),
            ),
          ),
          horizontalSpaces(14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${patientReservation.doctor.name}, ${patientReservation.doctor.specialization}',
                style: ClinicTextStyle.h4SemiBold(),
              ),
              verticalSpace(4),
              Text('NIK : ${patientReservation.doctor.nik}', style: ClinicTextStyle.h5Regular()),
              verticalSpace(4),
              Text('ID IHS : ${patientReservation.doctor.idIhs}', style: ClinicTextStyle.h5Regular()),
              verticalSpace(4),
              Text('SIP : ${patientReservation.doctor.sip}', style: ClinicTextStyle.h5Regular()),
            ],
          ),
        ],
      ),
      verticalSpace(14),
      Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: patientReservation.status == 'Batal'
              ? ClinicColor.danger.withOpacity(.2)
              : patientReservation.status == 'Proses'
                  ? ClinicColor.primary.withOpacity(.2)
                  : patientReservation.status == 'Selesai'
                      ? ClinicColor.success.withOpacity(.2)
                      : ClinicColor.warning.withOpacity(.2),
        ),
        child: Text(
          'Identitas Pasien',
          style: ClinicTextStyle.h4SemiBold().copyWith(
              color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.black),
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
                  'Nama Pasien',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  patientReservation.patient.name,
                  style: ClinicTextStyle.h4SemiBold(),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jenis Kelamin',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  patientReservation.patient.gender,
                  style: ClinicTextStyle.h4SemiBold(),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tempat Lahir',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  patientReservation.patient.birthPlace,
                  style: ClinicTextStyle.h4SemiBold(),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tanggal Lahir',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  DateTimeFormatter.dMMMMyyy(patientReservation.patient.birthDate.toString()),
                  style: ClinicTextStyle.h4SemiBold(),
                )
              ],
            ),
          ),
        ],
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
                  'NIK',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  patientReservation.patient.nik,
                  style: ClinicTextStyle.h4SemiBold(),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'No Kartu Keluarga',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  patientReservation.patient.noKk,
                  style: ClinicTextStyle.h4SemiBold(),
                )
              ],
            ),
          ),
          Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Perkawinan',
                  style: ClinicTextStyle.h4Regular()
                      .copyWith(color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8)),
                ),
                Text(
                  patientReservation.patient.maritalStatus,
                  style: ClinicTextStyle.h4SemiBold(),
                )
              ],
            ),
          ),
          const Flexible(
            flex: 1,
            fit: FlexFit.tight,
            child: SizedBox(),
          ),
        ],
      ),
      verticalSpace(14),
    ];
