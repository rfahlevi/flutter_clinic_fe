import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic/domain/entities/patient.dart';
import 'package:flutter_clinic/domain/entities/user.dart';
import 'package:flutter_clinic/presentation/extension/datetime_formatter.dart';

import '../../../../misc/clinic_color.dart';
import '../../../../misc/clinic_textstyle.dart';
import '../../../../misc/spacing.dart';

Future<dynamic> detailPatientDialog({
  required BuildContext context,
  required Patient patient,
  required VoidCallback onTapReservation,
  required VoidCallback onTapEdit,
  required bool canEdit,
  required User? user,
  required ThemeData? theme,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pasien : ${patient.name}',
            style: ClinicTextStyle.h3SemiBold(),
          ),
          if (canEdit == true || user != null && user.role != 'dokter')
            IconButton(
                onPressed: onTapEdit,
                icon: Icon(
                  CupertinoIcons.arrow_up_right_square_fill,
                  size: 30,
                  color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.darkBg,
                ))
        ],
      ),
      contentPadding: const EdgeInsets.all(24),
      content: SizedBox(
        width: 500,
        child: ListView(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NIK :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.nik,
                        style: ClinicTextStyle.h4Medium(),
                      ),
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
                        'No KK :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.noKk,
                        style: ClinicTextStyle.h4Medium(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            verticalSpace(14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Telepon :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.phone,
                        style: ClinicTextStyle.h4Medium(),
                      ),
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
                        'Email :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.email ?? '-',
                        style: ClinicTextStyle.h4Medium(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            verticalSpace(14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Jenis Kelamin :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.gender,
                        style: ClinicTextStyle.h4Medium(),
                      ),
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
                        'Tempat Lahir :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.birthPlace,
                        style: ClinicTextStyle.h4Medium(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            verticalSpace(14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tanggal Lahir :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        DateTimeFormatter.dMMMMyyy(patient.birthDate.toString()),
                        style: ClinicTextStyle.h4Medium(),
                      ),
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
                        'Alamat Lengkap :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.addressLine,
                        style: ClinicTextStyle.h4Medium(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            verticalSpace(14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RT/RW :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        '${patient.rt}/${patient.rw}',
                        style: ClinicTextStyle.h4Medium(),
                      ),
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
                        'Kelurahan :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.village,
                        style: ClinicTextStyle.h4Medium(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            verticalSpace(14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Kecamatan :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.district,
                        style: ClinicTextStyle.h4Medium(),
                      ),
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
                        'Kota :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.city,
                        style: ClinicTextStyle.h4Medium(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            verticalSpace(14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Province :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.province,
                        style: ClinicTextStyle.h4Medium(),
                      ),
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
                        'Kode Pos :',
                        style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
                      ),
                      Text(
                        patient.postalCode,
                        style: ClinicTextStyle.h4Medium(),
                      ),
                    ],
                  ),
                )
              ],
            ),
            verticalSpace(14),
            Text(
              'Status Perkawinan :',
              style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
            ),
            Text(
              patient.maritalStatus,
              style: ClinicTextStyle.h4Medium(),
            ),
            verticalSpace(7),
          ],
        ),
      ),
      actions: user != null && user.role != 'dokter'
          ? [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: onTapReservation,
                    child: const Text('Reservasi'),
                  ),
                ],
              )
            ]
          : null,
    ),
  );
}
