// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_clinic/presentation/screens/transaction/methods/qris_box_payment.dart';
import 'package:flutter_clinic/presentation/screens/transaction/methods/tunai_box_payment.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import 'package:flutter_clinic/domain/entities/medical_record.dart';
import 'package:flutter_clinic/domain/entities/payment.dart';
import 'package:flutter_clinic/presentation/blocs/patient_reservation/get_patient_reservations_bloc/get_patient_reservations_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/payment/create_payment_bloc/create_payment_bloc.dart';
import 'package:flutter_clinic/presentation/blocs/payment/qris_qr_generate_bloc/qris_qr_generate_bloc.dart';
import 'package:flutter_clinic/presentation/extension/clinic_alert.dart';
import 'package:flutter_clinic/presentation/extension/rupiah_formatter.dart';
import 'package:flutter_clinic/presentation/misc/clinic_color.dart';
import 'package:flutter_clinic/presentation/misc/clinic_textstyle.dart';
import 'package:flutter_clinic/presentation/screens/main/main_screen.dart';

import '../../blocs/payment/check_payment_status_bloc/check_payment_status_bloc.dart';
import 'service/transaction_service.dart';

class CheckoutTransactionScreen extends StatefulWidget {
  static const routerName = 'checkout-transaction';
  final MedicalRecord medicalRecord;
  final String paymentMethod;
  const CheckoutTransactionScreen({
    super.key,
    required this.medicalRecord,
    required this.paymentMethod,
  });

  @override
  State<CheckoutTransactionScreen> createState() => _CheckoutTransactionScreenState();
}

class _CheckoutTransactionScreenState extends State<CheckoutTransactionScreen> {
  TextEditingController cashC = TextEditingController();
  String cashback = '0';
  Duration? checkStatusDuration;
  Timer? timerPeriodic;
  String? paymentMethod;

  calculateCashback() {
    final result =
        int.parse(cashC.text.isEmpty ? '0' : cashC.text) - widget.medicalRecord.patientReservation.totalPrice!;
    cashback = result.toString();

    if (int.parse(cashback) < 0) {
      cashback = '0';
    }
    return cashback;
  }

  @override
  void initState() {
    setState(() {
      paymentMethod = widget.paymentMethod;
      if (paymentMethod == 'QRIS') {
        context.read<QrisQrGenerateBloc>().add(
              QrisQrGenerateEvent.getQrCode(
                grossAmount: widget.medicalRecord.patientReservation.totalPrice!,
              ),
            );
      } else {
        cashC.text = '0';
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    cashC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CreatePaymentBloc, CreatePaymentState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              failed: (message) {
                ClinicAlert.error(context: context, content: message);
              },
              success: (payment) {
                successPaymentDialog(
                  context: context,
                  payment: payment,
                );
              },
            );
          },
        ),
        BlocListener<CheckPaymentStatusBloc, CheckPaymentStatusState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              success: (qrisCallback) {
                if (qrisCallback.transactionStatus == 'settlement') {
                  context.read<CreatePaymentBloc>().add(
                        CreatePaymentEvent.doCreate(
                          patientReservationId: widget.medicalRecord.patientReservation.id,
                          paymentMethod: 'QRIS',
                          totalPrice: widget.medicalRecord.patientReservation.totalPrice!,
                        ),
                      );
                  timerPeriodic?.cancel();
                } else if (paymentMethod != 'QRIS') {
                  timerPeriodic?.cancel();
                }
              },
            );
          },
        ),
        BlocListener<QrisQrGenerateBloc, QrisQrGenerateState>(
          listener: (context, state) {
            state.maybeWhen(
              orElse: () {},
              success: (generateResult) {
                checkStatusDuration = const Duration(seconds: 7);
                if (paymentMethod == 'QRIS') {
                  timerPeriodic = Timer.periodic(checkStatusDuration!, (timer) {
                    context.read<CheckPaymentStatusBloc>().add(
                          CheckPaymentStatusEvent.doCheck(
                            orderId: int.parse(generateResult.orderId),
                          ),
                        );
                  });
                } else {
                  timerPeriodic?.cancel();
                }
              },
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: Padding(
            padding: const EdgeInsets.all(20),
            child: paymentMethod == 'QRIS'
                ? qrisBoxPayment(
                    context: context,
                    medicalRecord: widget.medicalRecord,
                    onTapQRIS: () {
                      setState(() {
                        paymentMethod = 'QRIS';
                        context.read<QrisQrGenerateBloc>().add(
                              QrisQrGenerateEvent.getQrCode(
                                grossAmount: widget.medicalRecord.patientReservation.totalPrice!,
                              ),
                            );
                        context.pop();
                      });
                    },
                    onTapTunai: () {
                      setState(() {
                        setState(() {
                          paymentMethod = 'Tunai';
                          cashC.text = '0';
                          context.pop();
                        });
                      });
                    },
                  )
                : tunaiBoxPayment(
                    context: context,
                    medicalRecord: widget.medicalRecord,
                    cashC: cashC,
                    cashback: cashback,
                    cashAmount: SizedBox(
                      height: 140,
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          childAspectRatio: 16 / 7,
                          mainAxisSpacing: 7,
                          crossAxisSpacing: 7,
                        ),
                        itemCount: 8,
                        itemBuilder: (context, index) {
                          return OutlinedButton(
                            onPressed: () {
                              setState(() {
                                if (cashC.text.isEmpty) {
                                  cashC.text = TransactionService.cashAmount()[index];
                                } else {
                                  cashC.text =
                                      (int.parse(cashC.text) + int.parse(TransactionService.cashAmount()[index]))
                                          .toString();
                                }

                                calculateCashback();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: ClinicColor.primary,
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              '+${rupiahFormatter(TransactionService.cashAmount()[index])}',
                              style: ClinicTextStyle.h5SemiBold().copyWith(color: ClinicColor.primary),
                            ),
                          );
                        },
                      ),
                    ),
                    onTapQRIS: () {
                      setState(() {
                        paymentMethod = 'QRIS';
                        context.read<QrisQrGenerateBloc>().add(
                              QrisQrGenerateEvent.getQrCode(
                                grossAmount: widget.medicalRecord.patientReservation.totalPrice!,
                              ),
                            );
                        context.pop();
                      });
                    },
                    onTapTunai: () {
                      setState(() {
                        setState(() {
                          paymentMethod = 'Tunai';
                          cashC.text = '0';
                          cashback = '0';
                          context.pop();
                        });
                      });
                    },
                    onChanged: (value) {
                      setState(() {
                        cashC.text = value;

                        calculateCashback();
                      });
                    },
                    onConfirmation: () {
                      if (cashC.text.isEmpty) {
                        ClinicAlert.notice(context: context, content: 'Masukkan nominal tunai');
                      } else if (int.parse(cashC.text) < widget.medicalRecord.patientReservation.totalPrice!) {
                        ClinicAlert.notice(context: context, content: 'Uang tunai tidak mencukupi');
                      } else {
                        context.read<CreatePaymentBloc>().add(
                              CreatePaymentEvent.doCreate(
                                patientReservationId: widget.medicalRecord.patientReservation.id,
                                paymentMethod: 'Tunai',
                                totalPrice: widget.medicalRecord.patientReservation.totalPrice!,
                              ),
                            );
                      }
                    },
                  )),
      ),
    );
  }

  Future<dynamic> successPaymentDialog({
    required BuildContext context,
    required Payment payment,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        title: SizedBox(
          width: MediaQuery.of(context).size.height / 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              LottieBuilder.asset(
                'assets/lotties/lottie_success_payment.json',
                repeat: false,
                frameRate: FrameRate.max,
                alignment: Alignment.topCenter,
                width: MediaQuery.of(context).size.height / 3.5,
                height: MediaQuery.of(context).size.height / 3.5,
                fit: BoxFit.fitWidth,
              ),
            ],
          ),
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Berhasil melakukan pembayaran sebesar',
              style: ClinicTextStyle.h4Medium(),
              textAlign: TextAlign.center,
            ),
            Text(
              rupiahFormatter(payment.totalPrice.toString()),
              style: ClinicTextStyle.h4Bold().copyWith(color: ClinicColor.primary),
            )
          ],
        ),
        titlePadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              context.goNamed(MainScreen.routerName);
              context.read<GetPatientReservationsBloc>().add(
                    const GetPatientReservationsEvent.doGet(patient: ''),
                  );
            },
            child: const Text('Kembali ke Dashboard'),
          ),
        ],
      ),
    );
  }
}
