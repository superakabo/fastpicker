import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'linear_sheet.dart';
import 'utilities/strings.dart';

class MultiSelectBanner extends StatelessWidget {
  final AnimationController controller;
  final ValueNotifier<List<AssetEntity>> selectedMediaRef;
  final void Function(List<AssetEntity>)? onComplete;
  final Strings strings;

  const MultiSelectBanner({
    required this.controller,
    required this.selectedMediaRef,
    required this.strings,
    required this.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

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
              ValueListenableBuilder<List<AssetEntity>>(
                valueListenable: selectedMediaRef,
                child: Text(strings.done),
                builder: (context, mediaAssets, child) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      elevation: 0,
                      minimumSize: Size.zero,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                    ),
                    onPressed: mediaAssets.isEmpty
                        ? null
                        : () {
                            onComplete?.call(mediaAssets);
                            if (navigator.canPop()) navigator.pop(mediaAssets);
                          },
                    child: child!,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
