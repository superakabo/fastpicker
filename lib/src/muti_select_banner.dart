import 'package:flutter/material.dart';

import 'linear_sheet.dart';
import 'utilities/strings.dart';

class MultiSelectBanner extends StatelessWidget {
  final AnimationController controller;
  final Strings strings;

  const MultiSelectBanner({
    required this.controller,
    required this.strings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LinearSheet(
      elevation: 8,
      controller: controller,
      alignment: AlignmentDirectional.bottomStart,
      animationAlignment: AlignmentDirectional.topStart,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(strings.addUpTo10PhotosAndVideos),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  elevation: 0,
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 16,
                  ),
                ),
                onPressed: () {},
                child: Text(strings.done),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
