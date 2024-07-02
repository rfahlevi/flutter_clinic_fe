import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clinic/domain/entities/user.dart';
import 'package:go_router/go_router.dart';

import '../../../../misc/clinic_color.dart';
import '../../../../misc/clinic_textstyle.dart';
import '../add_clinic_service_screen.dart';

PreferredSizeWidget clinicServicesAppbar({
  required BuildContext context,
  required TabController? tabController,
  required User? user,
}) =>
    AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: ClinicColor.white,
      title: Text(
        'Layanan Klinik',
        style: ClinicTextStyle.h3SemiBold(),
      ),
      centerTitle: true,
      actions: [
        if (user != null && user.role == 'admin')
          IconButton(
            onPressed: () => context.goNamed(AddClinicServiceScreen.routerName),
            icon: const Icon(
              CupertinoIcons.add_circled_solid,
              // size: 30,
            ),
          ),
      ],
      bottom: TabBar(
        controller: tabController,
        labelColor: Theme.of(context).colorScheme.onBackground,
        indicator: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(12),
            topLeft: Radius.circular(12),
          ),
        ),
        tabAlignment: TabAlignment.center,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.tab,
        unselectedLabelColor: ClinicColor.white,
        isScrollable: true,
        tabs: [
          Tab(
            child: Text(
              'Obat-obatan',
              style: ClinicTextStyle.h4Medium(),
            ),
          ),
          Tab(
            child: Text(
              'Treatment',
              style: ClinicTextStyle.h4Medium(),
            ),
          ),
          Tab(
            child: Text(
              'Konsultasi',
              style: ClinicTextStyle.h4Medium(),
            ),
          ),
        ],
      ),
    );
