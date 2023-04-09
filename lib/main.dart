import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'src/fast_picker_scaffold.dart';
import 'src/utilities/strings.dart';

class FastPicker extends StatelessWidget {
  final ThemeData theme;
  final Strings strings;
  final int maxSelection;
  final void Function(List<AssetEntity>)? onComplete;

  const FastPicker({
    required this.theme,
    this.strings = const Strings(),
    this.maxSelection = 10,
    this.onComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: theme.copyWith(
        bannerTheme: const MaterialBannerThemeData(
          dividerColor: Colors.transparent,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          shape: Border(),
        ),
      ),
      child: AccessibilityTools(
        minimumTapAreas: const MinimumTapAreas(
          mobile: 32,
          desktop: 32,
        ),
        child: FastPickerScaffold(
          maxSelection: maxSelection,
          onComplete: onComplete,
          strings: strings,
        ),
      ),
    );
  }
}
