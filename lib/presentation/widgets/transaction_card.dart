// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_clinic/domain/entities/payment.dart';

import '../blocs/theme/toggle_theme_bloc/toggle_theme_bloc.dart';
import '../extension/datetime_formatter.dart';
import '../extension/rupiah_formatter.dart';
import '../misc/clinic_color.dart';
import '../misc/clinic_textstyle.dart';
import '../misc/spacing.dart';

class TransactionCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback onTap;
  const TransactionCard({
    super.key,
    required this.payment,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData? theme = context.watch<ToggleThemeBloc>().state.whenOrNull(themeResult: (themeResult) => themeResult);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: ClinicColor.white.withOpacity(.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ClinicColor.primary.withOpacity(0.2))),
      child: InkWell(
        onTap: onTap,
        splashColor: ClinicColor.primary.withOpacity(.1),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              height: 125,
              decoration: BoxDecoration(
                color: ClinicColor.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                border: Border.all(
                  color: ClinicColor.primary.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    DateTimeFormatter.dMy(payment.createdAt),
                    style: ClinicTextStyle.h5Regular().copyWith(color: ClinicColor.white),
                  ),
                ],
              ),
            ),
            horizontalSpaces(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${payment.patientReservation.patient.name} (${payment.patientReservation.patient.gender})',
                    style: ClinicTextStyle.h4SemiBold(),
                  ),
                  verticalSpace(4),
                  Text(
                    'Ditangani Oleh : ${payment.patientReservation.doctor.name}, ${payment.patientReservation.doctor.specialization}',
                    style: ClinicTextStyle.h5Regular().copyWith(fontStyle: FontStyle.italic),
                  ),
                  verticalSpace(4),
                  Text(
                    'Tipe Pembayaran : ${payment.paymentMethod}',
                    style: ClinicTextStyle.h5Regular(),
                  ),
                  verticalSpace(4),
                  Text(
                    'Total Bayar : ${rupiahFormatter(payment.totalPrice.toString())}',
                    style: ClinicTextStyle.h5SemiBold().copyWith(
                        color: theme?.colorScheme.surface == ClinicColor.darkBg
                            ? ClinicColor.warning
                            : ClinicColor.primary),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
