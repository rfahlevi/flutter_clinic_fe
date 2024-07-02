import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../misc/clinic_color.dart';
import '../../../../misc/clinic_textstyle.dart';
import '../../../../misc/spacing.dart';

List<Widget> profilePhotoPicker({
  required VoidCallback onTap,
  required String? photoPath,
  required ThemeData? theme,
}) =>
    [
      Text(
        'Foto Profil',
        style: ClinicTextStyle.h4Regular(),
      ),
      verticalSpace(7),
      Row(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: ClinicColor.border.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: ClinicColor.border),
              ),
              child: photoPath == null
                  ? Icon(
                      CupertinoIcons.photo,
                      size: 40,
                      color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.black,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FadeInImage(
                        placeholder: const AssetImage('assets/images/img_placeholder.png'),
                        image: photoPath.contains('http') ? NetworkImage(photoPath) : Image.file(File(photoPath)).image,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset('assets/images/img_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
            ),
          ),
          horizontalSpaces(14),
          if (photoPath != null)
            SizedBox(
              width: 500,
              child: Text(
                photoPath.split('/').last,
                style: ClinicTextStyle.h4Regular(),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
      verticalSpace(14),
    ];
