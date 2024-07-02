import 'package:flutter/material.dart';
import 'package:flutter_clinic/domain/entities/doctor.dart';
import 'package:flutter_clinic/domain/entities/user.dart';

import '../../../../misc/clinic_color.dart';
import '../../../../misc/clinic_textstyle.dart';
import '../../../../misc/spacing.dart';

Future<dynamic> detailDoctorDialog({
  required BuildContext context,
  required Doctor doctor,
  required User? user,
  required VoidCallback onTapDelete,
  required VoidCallback onTapEdit,
}) {
  return showAdaptiveDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AlertDialog(
      title: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/img_placeholder.png'),
                image: doctor.photo != null && doctor.photo!.contains('https')
                    ? NetworkImage(doctor.photo!)
                    : NetworkImage('http://www.laravel-clinic-be.test/storage/doctors/${doctor.photo}'),
                imageErrorBuilder: (context, error, stackTrace) => Image.asset('assets/images/img_placeholder.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          verticalSpace(10),
          Text(
            '${doctor.name}, ${doctor.specialization}',
            style: ClinicTextStyle.h3SemiBold(),
          ),
          verticalSpace(14),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SIP :',
              style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
            ),
            Text(
              doctor.sip,
              style: ClinicTextStyle.h4Medium(),
            ),
            verticalSpace(7),
            Text(
              'NIK :',
              style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
            ),
            Text(
              doctor.nik ?? '-',
              style: ClinicTextStyle.h4Medium(),
            ),
            verticalSpace(7),
            Text(
              'ID IHS :',
              style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
            ),
            Text(
              doctor.idIhs ?? '-',
              style: ClinicTextStyle.h4Medium(),
            ),
            verticalSpace(7),
            Text(
              'No Telepon :',
              style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
            ),
            Text(
              doctor.phone,
              style: ClinicTextStyle.h4Medium(),
            ),
            verticalSpace(7),
            Text(
              'Email :',
              style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
            ),
            Text(
              doctor.email,
              style: ClinicTextStyle.h4Medium(),
            ),
            verticalSpace(7),
            Text(
              'Alamat :',
              style: ClinicTextStyle.h4Regular().copyWith(color: ClinicColor.grey),
            ),
            Text(
              doctor.address ?? '-',
              style: ClinicTextStyle.h4Medium(),
            ),
            verticalSpace(7),
          ],
        ),
      ),
      actions: user != null && user.role == 'admin'
          ? [
              ElevatedButton(
                onPressed: onTapDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  side: BorderSide(
                    color: ClinicColor.grey,
                  ),
                ),
                child: Text(
                  'Hapus',
                  style: ClinicTextStyle.h4SemiBold().copyWith(color: ClinicColor.grey),
                ),
              ),
              verticalSpace(14),
              ElevatedButton(
                onPressed: onTapEdit,
                child: const Text('Edit'),
              ),
            ]
          : null,
    ),
  );
}
