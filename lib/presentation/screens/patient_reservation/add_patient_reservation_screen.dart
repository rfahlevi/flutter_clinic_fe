// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/domain/entities/doctor.dart';
import 'package:flutter_clinic/domain/entities/doctor_schedule.dart';

import 'package:flutter_clinic/domain/entities/patient.dart';
import 'package:flutter_clinic/domain/entities/patient_reservation.dart';
import 'package:flutter_clinic/presentation/blocs/master/doctor_schedule/get_doctor_schedules_bloc/get_doctor_schedules_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/patient_reservation/create_patient_reservation_bloc/create_patient_reservation_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/patient_reservation/get_patient_reservations_bloc/get_patient_reservations_bloc.dart';
import 'package:flutter_clinic/presentation/extension/clinic_alert.dart';
import 'package:flutter_clinic/presentation/extension/datetime_formatter.dart';
import 'package:flutter_clinic/presentation/extension/day_formatter.dart';
import 'package:flutter_clinic/presentation/misc/clinic_color.dart';
import 'package:flutter_clinic/presentation/misc/spacing.dart';
import 'package:flutter_clinic/presentation/screens/patient_reservation/methods/add_patient_reservation_appbar.dart';
import 'package:flutter_clinic/presentation/screens/patient_reservation/methods/add_patient_reservation_button.dart';
import 'package:flutter_clinic/presentation/screens/patient_reservation/methods/handled_by.dart';
import 'package:flutter_clinic/presentation/screens/patient_reservation/methods/patient_address.dart';
import 'package:flutter_clinic/presentation/screens/patient_reservation/methods/patient_identity.dart';
import 'package:flutter_clinic/presentation/screens/patient_reservation/methods/reservation_date_and_complaint.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/master/doctor/get_doctors_bloc/get_doctors_bloc.dart';
import '../../extension/clinic_loading.dart';
import '../../extension/search_form.dart';
import '../../misc/clinic_textstyle.dart';
import '../../widgets/doctor_reservation_card.dart';

class AddPatientReservationScreen extends StatefulWidget {
  static const routerName = 'add-patient-reservation';
  final Patient patient;
  const AddPatientReservationScreen({
    super.key,
    required this.patient,
  });

  @override
  State<AddPatientReservationScreen> createState() => _AddPatientReservationScreenState();
}

class _AddPatientReservationScreenState extends State<AddPatientReservationScreen> {
  TextEditingController complaintC = TextEditingController();
  TextEditingController doctorSearchC = TextEditingController();
  Doctor? selectedDoctor;
  ScrollController scrollC = ScrollController();
  bool isNext = false;

  @override
  void initState() {
    scrollC.addListener(() {
      if (scrollC.position.maxScrollExtent == scrollC.offset) {
        isNext = context.read<GetDoctorsBloc>().isNext;
        if (isNext) {
          context.read<GetDoctorsBloc>().add(GetDoctorsEvent.getNext(name: doctorSearchC.text));
        }
      }
    });

    context.read<GetDoctorSchedulesBloc>().add(const GetDoctorSchedulesEvent.getAll(name: ''));
    super.initState();
  }

  @override
  void dispose() {
    complaintC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int? queueNumber = context.watch<GetPatientReservationsBloc>().state.whenOrNull(
        success: (patientReservations) =>
            patientReservations
                .where((element) =>
                    DateTimeFormatter.dMMMMyyy(element.scheduleTime) ==
                    DateTimeFormatter.dMMMMyyy(DateTime.now().toString()))
                .length +
            1);

    return BlocListener<CreatePatientReservationBloc, CreatePatientReservationState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          failed: (message) {
            ClinicAlert.error(context: context, content: message);
          },
          success: (patientReservation) {
            successDialog(context: context, patientReservation: patientReservation);
          },
        );
      },
      child: Scaffold(
        appBar: addPatientReservationAppbar(),
        bottomNavigationBar: addPatientReservationButton(
          onPressed: () {
            if (selectedDoctor == null) {
              ClinicAlert.notice(context: context, content: 'Pilih Dokter terlebih dahulu');
            } else if (complaintC.text.isEmpty) {
              ClinicAlert.notice(context: context, content: 'Keluhan pasien tidak boleh kosong');
            } else {
              context.read<CreatePatientReservationBloc>().add(
                    CreatePatientReservationEvent.doCreate(
                      doctorId: selectedDoctor!.id,
                      patientId: widget.patient.id,
                      scheduleTime: DateTime.now(),
                      complaint: complaintC.text,
                      queueNumber: queueNumber ?? 1,
                    ),
                  );
            }
          },
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              ...handledBy(
                context: context,
                selectedDoctor: selectedDoctor,
                doctorSearchC: doctorSearchC,
                scrollC: scrollC,
                onPressed: () {
                  context.read<GetDoctorsBloc>().add(const GetDoctorsEvent.getFirst(name: ''));
                  selectDoctorModal(context);
                },
              ),
              ...patientIdentity(
                context: context,
                patient: widget.patient,
              ),
              ...patientAddress(
                context: context,
                patient: widget.patient,
              ),
              ...reservationAddressAndComplaint(
                context: context,
                patient: widget.patient,
                complaintC: complaintC,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> successDialog({
    required BuildContext context,
    required PatientReservation patientReservation,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: ClinicColor.primary,
              ),
              child: Center(
                child: Text(
                  patientReservation.queueNumber.toString(),
                  style: ClinicTextStyle.h1Bold().copyWith(
                    fontSize: 100,
                    color: ClinicColor.white,
                  ),
                ),
              ),
            ),
            verticalSpace(14),
            Text(
              'Berikut adalah nomor antrian untuk pasien',
              style: ClinicTextStyle.h4Medium(),
            ),
            Text(
              patientReservation.patient.name,
              style: ClinicTextStyle.h1Bold(),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
            width: 100,
            child: ElevatedButton(
              onPressed: () {
                context.read<GetPatientReservationsBloc>().add(const GetPatientReservationsEvent.doGet(patient: ''));
                context.pop();
                context.pop();
              },
              child: const Text('Oke'),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> selectDoctorModal(BuildContext context) {
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
                searchC: doctorSearchC,
                hintText: 'Ketik nama atau NIK dokter',
                label: 'Cari Dokter',
                debouncerFunc: () =>
                    context.read<GetDoctorsBloc>().add(GetDoctorsEvent.getFirst(name: doctorSearchC.text)),
                suffixOnPressed: () =>
                    context.read<GetDoctorsBloc>().add(GetDoctorsEvent.getFirst(name: doctorSearchC.text)),
                onSubmitted: (value) => context.read<GetDoctorsBloc>().add(GetDoctorsEvent.getFirst(name: value)),
              ),
            ),
            BlocBuilder<GetDoctorsBloc, GetDoctorsState>(
              builder: (context, state) {
                return state.maybeWhen(
                  orElse: () => ClinicLoading.shimmer(context),
                  failed: (message) => Text(
                    message,
                    style: ClinicTextStyle.h4Regular(),
                  ),
                  success: (doctors, isNext) {
                    // Filter Jadwal hari ini
                    List<DoctorSchedule>? scheduleToday = context.watch<GetDoctorSchedulesBloc>().state.whenOrNull(
                        success: (doctorSchedules) => doctorSchedules
                            .where((element) =>
                                element.day == DayFormatter.convertToLocal(DateTime.now().weekday) &&
                                element.status == 'Aktif')
                            .toList());

                    // Dokter berdasarkan jadwal hari ini
                    List<Doctor> doctorTodays = doctors
                        .where((element) => scheduleToday?.map((e) => e.doctor.id).contains(element.id) ?? false)
                        .toList();

                    log('Schedule Today ${scheduleToday?.map((e) => jsonEncode(e)).toList()}');
                    log('Doctors ${doctors.map((e) => jsonEncode(e)).toList()}');

                    isNext = doctorTodays.length > 10;

                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: doctorTodays.length + 1,
                        controller: scrollC,
                        itemBuilder: (context, index) {
                          if (index < doctorTodays.length) {
                            return DoctorReservationcard(
                              doctor: doctorTodays[index],
                              onTap: () {
                                setState(() {
                                  selectedDoctor = doctorTodays[index];
                                  context.pop();
                                });
                              },
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
}
