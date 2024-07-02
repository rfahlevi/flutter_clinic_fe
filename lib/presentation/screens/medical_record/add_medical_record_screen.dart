// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/domain/entities/clinic_service.dart';

import 'package:flutter_clinic/domain/entities/patient_reservation.dart';
import 'package:flutter_clinic/domain/entities/user.dart';
import 'package:flutter_clinic/presentation/blocs/medical_record/create_medical_record_bloc/create_medical_record_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/patient_reservation/get_patient_reservations_bloc/get_patient_reservations_bloc.dart';
import 'package:flutter_clinic/presentation/extension/clinic_alert.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/add_medical_record_appbar.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/cancel_button.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/diagnose_and_medical_treatment_form.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/doctor_notes_form.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/handled_by.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/medical_service.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/reservation_canceled.dart';
import 'package:flutter_clinic/presentation/screens/medical_record/methods/submit_button.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/get_user/get_user_bloc.dart';
import '../../blocs/master/clinic_service/get_clinic_services_bloc/get_clinic_services_bloc.dart';
import '../../blocs/theme/toggle_theme_bloc/toggle_theme_bloc.dart';

class AddMedicalRecordScreen extends StatefulWidget {
  static const routerName = 'add-medical-record';
  final PatientReservation patientReservation;
  const AddMedicalRecordScreen({
    super.key,
    required this.patientReservation,
  });

  @override
  State<AddMedicalRecordScreen> createState() => _AddMedicalRecordScreenState();
}

class _AddMedicalRecordScreenState extends State<AddMedicalRecordScreen> {
  TextEditingController diagnoseC = TextEditingController();
  TextEditingController medicalTreatmentC = TextEditingController();
  TextEditingController doctorNotesC = TextEditingController();
  TextEditingController searchC = TextEditingController();
  int totalAmount = 0;
  bool hasSelectedService = false;

  @override
  void initState() {
    context.read<GetClinicServicesBloc>().add(const GetClinicServicesEvent.clearChecked());
    super.initState();
  }

  @override
  void dispose() {
    diagnoseC.dispose();
    medicalTreatmentC.dispose();
    doctorNotesC.dispose();
    searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<ClinicService> selectedServices = context.watch<GetClinicServicesBloc>().state.whenOrNull(
            success: (clinicServices) => clinicServices.where((element) => element.isChecked == true).toList()) ??
        [];

    User? user = context.watch<GetUserBloc>().state.whenOrNull(success: (user) => user);
    ThemeData? theme = context.watch<ToggleThemeBloc>().state.whenOrNull(themeResult: (themeResult) => themeResult);

    return MultiBlocListener(
      listeners: [
        BlocListener<CreateMedicalRecordBloc, CreateMedicalRecordState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              failed: (message) {
                ClinicAlert.error(context: context, content: message);
              },
              success: (medicalRecord) {
                ClinicAlert.successful(context: context, content: 'Medical Record Berhasilimpan');
                context.read<GetPatientReservationsBloc>().add(const GetPatientReservationsEvent.doGet(patient: ''));
                context.pop();
              },
            );
          },
        ),
        BlocListener<GetClinicServicesBloc, GetClinicServicesState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              success: (clinicServices) {
                hasSelectedService = clinicServices.where((element) => element.isChecked == true).isNotEmpty;
              },
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: addMedicalRecordAppbar(context),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              ...handledBy(
                context: context,
                patientReservation: widget.patientReservation,
                theme: theme,
              ),
              ...diagnoseAndMedicalTreatmentForm(
                context: context,
                patientReservation: widget.patientReservation,
                diagnoseC: diagnoseC,
                medicalTreatmentC: medicalTreatmentC,
                user: user,
                theme: theme,
              ),
              ...doctorNotesForm(
                patientReservation: widget.patientReservation,
                doctorNotesC: doctorNotesC,
                user: user,
              ),
              ...medicalService(
                context: context,
                patientReservation: widget.patientReservation,
                searchC: searchC,
                hasSelectedService: hasSelectedService,
                totalAmount: totalAmount,
                user: user,
                theme: theme,
              ),
              if (user != null && user.role != 'user')
                ...submitButton(
                  patientReservation: widget.patientReservation,
                  onPressed: () {
                    if (diagnoseC.text.isEmpty) {
                      ClinicAlert.notice(context: context, content: 'Diagnosa penyakit harus diisi');
                    } else if (medicalTreatmentC.text.isEmpty) {
                      ClinicAlert.notice(context: context, content: 'Medical treatment harus diisi');
                    } else if (doctorNotesC.text.isEmpty) {
                      ClinicAlert.notice(context: context, content: 'Catatan dokter harus diisi');
                    } else if (selectedServices.isEmpty) {
                      ClinicAlert.notice(context: context, content: 'Pilih minimal 1 medical service');
                    } else {
                      context.read<CreateMedicalRecordBloc>().add(
                            CreateMedicalRecordEvent.doCreate(
                              patientReservationId: widget.patientReservation.id,
                              diagnosis: diagnoseC.text,
                              medicalTreatment: medicalTreatmentC.text,
                              doctorNotes: doctorNotesC.text,
                              medicalRecordServices: List.generate(
                                selectedServices.length,
                                (index) => {
                                  'clinic_service_id': selectedServices[index].id,
                                  'qty': selectedServices[index].qty,
                                },
                              ),
                            ),
                          );
                    }
                  },
                ),
              cancelButton(
                context: context,
                patientReservation: widget.patientReservation,
              ),
              reservationCanceled(
                patientReservation: widget.patientReservation,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
