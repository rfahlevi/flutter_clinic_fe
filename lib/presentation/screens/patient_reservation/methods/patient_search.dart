import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/domain/entities/user.dart';
import 'package:flutter_clinic/presentation/blocs/master/patient/get_patients_bloc/get_patients_bloc.dart';
import 'package:flutter_clinic/presentation/extension/clinic_loading.dart';
import 'package:flutter_clinic/presentation/widgets/patient_card.dart';

import '../../../blocs/patient_reservation/get_patient_reservations_bloc/get_patient_reservations_bloc.dart';
import '../../../extension/search_form.dart';
import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';
import '../../../misc/spacing.dart';
import '../../../widgets/reservation_status.dart';

Widget patientSearch({
  required BuildContext context,
  required TextEditingController reservationSearchC,
  required TextEditingController patientSearchC,
  required ScrollController scrollC,
  required User? user,
}) =>
    Container(
      padding: const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 14),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SearchForm(
                    searchC: reservationSearchC,
                    hintText: 'Ketik nama atau NIK pasien',
                    label: 'Cari Reservasi',
                    debouncerFunc: () => context
                        .read<GetPatientReservationsBloc>()
                        .add(GetPatientReservationsEvent.doGet(patient: reservationSearchC.text)),
                    suffixOnPressed: () => context
                        .read<GetPatientReservationsBloc>()
                        .add(GetPatientReservationsEvent.doGet(patient: reservationSearchC.text)),
                    onSubmitted: (value) => context
                        .read<GetPatientReservationsBloc>()
                        .add(GetPatientReservationsEvent.doGet(patient: value))),
              ),
              if (user != null && user.role != 'dokter') horizontalSpaces(14),
              if (user != null && user.role != 'dokter')
                SizedBox(
                  width: 170,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<GetPatientsBloc>().add(const GetPatientsEvent.getFirst(patient: ''));
                      patientsModalBottomSheet(
                        context,
                        patientSearchC,
                        scrollC,
                        user,
                      );
                    },
                    child: const Text('Buat Reservasi'),
                  ),
                )
            ],
          ),
          verticalSpace(14),
          Text(
            'Data Pasien',
            style: ClinicTextStyle.h4SemiBold(),
          ),
          Divider(
            color: ClinicColor.border,
          ),
          Row(
            children: [
              ReservationStatus(
                label: 'Menunggu',
                color: ClinicColor.warning,
              ),
              ReservationStatus(
                label: 'Proses',
                color: ClinicColor.primary,
              ),
              ReservationStatus(
                label: 'Selesai',
                color: ClinicColor.success,
              ),
              ReservationStatus(
                label: 'Batal',
                color: ClinicColor.danger,
              )
            ],
          ),
        ],
      ),
    );

Future<dynamic> patientsModalBottomSheet(
    BuildContext context, TextEditingController patientSearchC, ScrollController scrollC, User? user) {
  return showModalBottomSheet(
    context: context,
    isDismissible: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
            margin: const EdgeInsets.only(bottom: 14),
            child: SearchForm(
              searchC: patientSearchC,
              hintText: 'Ketik nama atau NIK pasien',
              label: 'Cari Pasien',
              debouncerFunc: () =>
                  context.read<GetPatientsBloc>().add(GetPatientsEvent.getFirst(patient: patientSearchC.text)),
              suffixOnPressed: () =>
                  context.read<GetPatientsBloc>().add(GetPatientsEvent.getFirst(patient: patientSearchC.text)),
              onSubmitted: (value) => context.read<GetPatientsBloc>().add(GetPatientsEvent.getFirst(patient: value)),
            ),
          ),
          BlocBuilder<GetPatientsBloc, GetPatientsState>(
            builder: (context, state) {
              return state.maybeWhen(
                orElse: () => ClinicLoading.shimmer(context),
                failed: (message) => Text(
                  message,
                  style: ClinicTextStyle.h4Regular(),
                ),
                success: (patients, isNext) {
                  return Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: patients.length + 1,
                      controller: scrollC,
                      itemBuilder: (context, index) {
                        if (index < patients.length) {
                          return PatientCard(
                            patient: patients[index],
                            user: user,
                          );
                        } else if (isNext) {
                          return ClinicLoading.loadData(context);
                        } else {
                          return ClinicLoading.noDataMore(context);
                        }
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    ),
  );
}
