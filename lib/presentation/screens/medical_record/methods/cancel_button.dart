import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/domain/entities/patient_reservation.dart';
import 'package:go_router/go_router.dart';

import '../../../../data/datasources/patient_reservation/patient_reservation_external_datasource.dart';
import '../../../blocs/patient_reservation/cancel_patient_reservation_bloc/cancel_patient_reservation_bloc.dart';
import '../../../blocs/patient_reservation/get_patient_reservations_bloc/get_patient_reservations_bloc.dart';
import '../../../extension/clinic_alert.dart';
import '../../../extension/clinic_loading.dart';
import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';

Widget cancelButton({
  required BuildContext context,
  required PatientReservation patientReservation,
}) {
  if (patientReservation.status == 'Menunggu') {
    return ElevatedButton(
      onPressed: () => confirmDeleteReservation(context, patientReservation),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: ClinicColor.danger),
        ),
      ),
      child: Text(
        'Batalkan Reservasi',
        style: ClinicTextStyle.h4SemiBold().copyWith(
          color: ClinicColor.danger,
        ),
      ),
    );
  }

  return const SizedBox.shrink();
}

Future<dynamic> confirmDeleteReservation(
  BuildContext context,
  PatientReservation patientReservation,
) {
  return showAdaptiveDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => BlocProvider(
      create: (context) => CancelPatientReservationBloc(PatientReservationExternalDatasource()),
      child: BlocListener<CancelPatientReservationBloc, CancelPatientReservationState>(
        listener: (context, state) {
          state.maybeWhen(
            orElse: () {},
            success: (patienReservation) {
              ClinicAlert.successful(
                  context: context, content: 'Berhasil membatalkan reservasi : ${patienReservation.patient.name}');
              context.read<GetPatientReservationsBloc>().add(const GetPatientReservationsEvent.doGet(patient: ''));
              context.pop();
              context.pop();
            },
            failed: (message) {
              ClinicAlert.error(context: context, content: message);
            },
          );
        },
        child: AlertDialog.adaptive(
          title: Text(
            'Konfirmasi',
            style: ClinicTextStyle.h3SemiBold(),
          ),
          content: Text(
            'Apakah anda yakin ingin menghapus reservasi ${patientReservation.patient.name}?',
            style: ClinicTextStyle.h4Regular(),
          ),
          actions: [
            BlocBuilder<CancelPatientReservationBloc, CancelPatientReservationState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => TextButton(
                    onPressed: () => context
                        .read<CancelPatientReservationBloc>()
                        .add(CancelPatientReservationEvent.cancelById(id: patientReservation.id)),
                    child: Text(
                      'Oke',
                      style: ClinicTextStyle.h5SemiBold().copyWith(color: ClinicColor.danger),
                    ),
                  ),
                  loading: () => ClinicLoading.textButtonCircular(),
                );
              },
            ),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Batal'),
            ),
          ],
        ),
      ),
    ),
  );
}
