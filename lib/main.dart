import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/material.dart';

import 'src/fast_picker_scaffold.dart';
import 'src/utilities/strings.dart';

class FastPicker extends StatelessWidget {
  final ThemeData theme;
  final Strings strings;
  final int maxSelection;

  const FastPicker({
    required this.theme,
    this.strings = const Strings(),
    this.maxSelection = 10,
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
      child: FastPickerScaffold(
        maxSelection: maxSelection,
        strings: strings,
      ),
    );
  }
}
