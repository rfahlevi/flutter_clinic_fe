// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_clinic/domain/entities/clinic_service.dart';
import 'package:flutter_clinic/presentation/blocs/master/clinic_service/get_clinic_services_bloc/get_clinic_services_bloc.dart';

import '../blocs/theme/toggle_theme_bloc/toggle_theme_bloc.dart';
import '../extension/rupiah_formatter.dart';
import '../misc/clinic_color.dart';
import '../misc/clinic_textstyle.dart';

class SelectedClinicServiceCard extends StatefulWidget {
  final ClinicService clinicService;
  final int index;
  const SelectedClinicServiceCard({
    super.key,
    required this.clinicService,
    required this.index,
  });

  @override
  State<SelectedClinicServiceCard> createState() => _SelectedClinicServiceCardState();
}

class _SelectedClinicServiceCardState extends State<SelectedClinicServiceCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData? theme = context.watch<ToggleThemeBloc>().state.whenOrNull(themeResult: (themeResult) => themeResult);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      minVerticalPadding: 7,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kategori : ${widget.clinicService.category}',
            style: ClinicTextStyle.h5Regular().copyWith(
                color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.white : ClinicColor.grey),
          ),
          Text(
            widget.clinicService.name,
            style: ClinicTextStyle.h4SemiBold(),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Harga Satuan : ${rupiahFormatter(widget.clinicService.price.toString())}',
            style: ClinicTextStyle.h5Regular(),
          ),
          Text(
            'Subtotal : ${rupiahFormatter(widget.clinicService.subtotal.toString())}',
            style: ClinicTextStyle.h5Medium().copyWith(
              color: theme?.colorScheme.surface == ClinicColor.darkBg ? ClinicColor.warning : ClinicColor.primary,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: ClinicColor.border,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
            ),
            child: InkWell(
              onTap: () {
                context
                    .read<GetClinicServicesBloc>()
                    .add(GetClinicServicesEvent.decreaseQty(id: widget.clinicService.id));
              },
              splashColor: ClinicColor.grey,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                bottomLeft: Radius.circular(4),
              ),
              child: Icon(
                CupertinoIcons.minus,
                size: 14,
                color: ClinicColor.black,
              ),
            ),
          ),
          Container(
            width: 30,
            height: 25,
            decoration: BoxDecoration(
              color: ClinicColor.border.withOpacity(.2),
            ),
            child: Center(
              child: Text(
                widget.clinicService.qty.toString(),
                style: ClinicTextStyle.h5Regular(),
              ),
            ),
          ),
          Container(
            width: 25,
            height: 25,
            decoration: BoxDecoration(
              color: ClinicColor.warning,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
            ),
            child: InkWell(
              onTap: () {
                context.read<GetClinicServicesBloc>().add(
                      GetClinicServicesEvent.increaseQty(
                        id: widget.clinicService.id,
                      ),
                    );
              },
              splashColor: ClinicColor.grey,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(4),
                bottomRight: Radius.circular(4),
              ),
              child: Icon(
                CupertinoIcons.add,
                size: 14,
                color: ClinicColor.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
