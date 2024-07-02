import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/data/datasources/auth/auth_external_datasource.dart';
import 'package:flutter_clinic/presentation/blocs/theme/toggle_theme_bloc/toggle_theme_bloc.dart';
import 'package:flutter_clinic/presentation/extension/clinic_loading.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/datasources/auth/auth_local_datasource.dart';
import '../../../blocs/auth/logout/logout_bloc.dart';
import '../../../extension/clinic_alert.dart';
import '../../../extension/datetime_formatter.dart';
import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';
import '../../../misc/spacing.dart';
import '../../splash/splash_screen.dart';

List<Widget> mainHeader({
  required BuildContext context,
  required bool isDark,
  required Function(bool value) onChanged,
}) =>
    [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeInImage(
                placeholder: const AssetImage('assets/images/img_placeholder.png'),
                image: AssetImage(
                    isDark ? 'assets/images/img_clinic_logo_white.png' : 'assets/images/img_clinic_logo.png'),
                width: 150,
                height: 50,
                fit: BoxFit.cover,
                fadeInDuration: const Duration(milliseconds: 300),
                fadeOutDuration: const Duration(milliseconds: 300),
              ),
              verticalSpace(7),
              Text(
                DateTimeFormatter.fullDatetimeNow(),
                style: ClinicTextStyle.h4SemiBold(),
              )
            ],
          ),
          Row(
            children: [
              BlocBuilder<ToggleThemeBloc, ToggleThemeState>(
                builder: (context, state) {
                  return Switch.adaptive(
                    value: isDark,
                    activeColor: ClinicColor.primary,
                    thumbIcon: MaterialStateProperty.resolveWith(
                      (states) => Icon(
                        isDark ? CupertinoIcons.moon_stars_fill : CupertinoIcons.sun_max_fill,
                        color: ClinicColor.black,
                      ),
                    ),
                    onChanged: onChanged,
                  );
                },
              ),
              IconButton(
                onPressed: () => confirmLogoutDialog(context),
                icon: Icon(
                  Icons.logout_rounded,
                  size: 30,
                  color: ClinicColor.danger,
                ),
              ),
            ],
          ),
        ],
      ),
      verticalSpace(7),
      Divider(
        color: ClinicColor.border,
      ),
      verticalSpace(7),
    ];

Future<dynamic> confirmLogoutDialog(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => BlocProvider(
      create: (context) => LogoutBloc(AuthExternalDatasource()),
      child: BlocListener<LogoutBloc, LogoutState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            success: (message) {
              ClinicAlert.successful(context: context, content: message);
              context.goNamed(SplashScreen.routerName);
            },
            failed: (message) async {
              ClinicAlert.error(context: context, content: message);
              context.goNamed(SplashScreen.routerName);
              await AuthLocalDatasource().removeAuthData();
              await AuthLocalDatasource().removeToken();
            },
          );
        },
        child: AlertDialog.adaptive(
          title: Text(
            'Konfirmasi',
            style: ClinicTextStyle.h3SemiBold(),
          ),
          content: Text(
            'Apakah anda yakin ingin logout?',
            style: ClinicTextStyle.h4Regular(),
          ),
          actions: [
            BlocBuilder<LogoutBloc, LogoutState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => TextButton(
                    onPressed: () => context.read<LogoutBloc>().add(const LogoutEvent.doLogout()),
                    child: Text(
                      'Ya',
                      style: ClinicTextStyle.h4Medium(),
                    ),
                  ),
                  loading: () => ClinicLoading.textButtonCircular(),
                );
              },
            ),
            TextButton(
              onPressed: () => context.pop(),
              style: TextButton.styleFrom(foregroundColor: ClinicColor.danger),
              child: Text(
                'Tidak',
                style: ClinicTextStyle.h4Medium(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
