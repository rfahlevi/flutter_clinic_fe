import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';

Widget backButton(BuildContext context) => SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
          onPressed: () => context.pop(),
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.surface, side: BorderSide(color: ClinicColor.primary)),
          child: Text(
            'Kembali',
            style: ClinicTextStyle.h4SemiBold().copyWith(
              color: ClinicColor.primary,
            ),
          )),
    );
