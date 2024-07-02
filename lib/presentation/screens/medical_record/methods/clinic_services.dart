import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/master/clinic_service/get_clinic_services_bloc/get_clinic_services_bloc.dart';
import '../../../extension/clinic_loading.dart';
import '../../../extension/rupiah_formatter.dart';
import '../../../misc/clinic_color.dart';
import '../../../misc/clinic_textstyle.dart';
import '../../../misc/spacing.dart';
import '../../../widgets/empty_data.dart';

Widget clinicServices({
  required ThemeData? theme,
}) =>
    BlocConsumer<GetClinicServicesBloc, GetClinicServicesState>(
      listener: (context, state) {
        state.maybeWhen(
          orElse: () {},
          success: (clinicServices) {},
        );
      },
      builder: (context, state) {
        return state.maybeWhen(
          orElse: () => ClinicLoading.shimmer(context),
          failed: (message) => EmptyData(
            message: message,
            onPressed: () => context.read<GetClinicServicesBloc>().add(
                  const GetClinicServicesEvent.getAll(
                    name: '',
                  ),
                ),
          ),
          success: (clinicServices) {
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: clinicServices.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      BlocBuilder<GetClinicServicesBloc, GetClinicServicesState>(
                        builder: (context, state) {
                          return CheckboxListTile(
                            activeColor: theme?.colorScheme.surface == ClinicColor.darkBg
                                ? ClinicColor.warning
                                : ClinicColor.primary,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Kategori : ${clinicServices[index].category}',
                                  style: ClinicTextStyle.h5Regular().copyWith(
                                      color: theme?.colorScheme.surface == ClinicColor.darkBg
                                          ? ClinicColor.white
                                          : ClinicColor.grey),
                                ),
                                Text(
                                  clinicServices[index].name,
                                  style: ClinicTextStyle.h4SemiBold(),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              rupiahFormatter(clinicServices[index].price.toString()),
                              style: ClinicTextStyle.h4Regular(),
                            ),
                            value: clinicServices[index].isChecked,
                            onChanged: (value) {
                              context.read<GetClinicServicesBloc>().add(
                                    GetClinicServicesEvent.checkedToggle(
                                      index: index,
                                      value: value!,
                                    ),
                                  );
                            },
                          );
                        },
                      ),
                      verticalSpace(7),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
