import 'package:flutter/material.dart';

import 'linear_sheet.dart';

class PermissionBottomSheet extends StatelessWidget {
  final AnimationController controller;

  const PermissionBottomSheet(
    this.controller, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LinearSheet(
      heightFactor: 0,
      controller: controller,
      child: Column(
        children: [],
      ),
    );
  }
}
