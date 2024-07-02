import 'package:flutter/material.dart';
import 'package:flutter_clinic/presentation/misc/clinic_color.dart';
import 'package:flutter_clinic/presentation/misc/clinic_textstyle.dart';
import 'package:go_router/go_router.dart';

Widget backButton(BuildContext context) => SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
        onPressed: () => context.pop(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: ClinicColor.primary,
            ),
          ),
        ),
        child: Text(
          'Kembali',
          style: ClinicTextStyle.h4SemiBold().copyWith(
            color: ClinicColor.primary,
          ),
        ),
      ),
    );
