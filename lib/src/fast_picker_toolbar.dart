import 'package:flutter/cupertino.dart';

import 'album_drawer_button.dart';
import 'models/album_model.dart';
import 'multi_select_toggle_button.dart';
import 'utilities/strings.dart';

class FastPickerToolbar extends StatelessWidget implements PreferredSizeWidget {
  final AnimationController multiSelectController;
  final AnimationController albumController;
  final ValueNotifier<AlbumModel> selectedAlbumRef;
  final Strings strings;
  final bool visible;

  const FastPickerToolbar({
    required this.albumController,
    required this.multiSelectController,
    required this.selectedAlbumRef,
    required this.visible,
    required this.strings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AlbumDrawerButton(
              controller: albumController,
              strings: strings,
              selectedAlbumRef: selectedAlbumRef,
            ),
            MultiSelectToggleButton(
              controller: multiSelectController,
              strings: strings,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(visible ? 48 : 0);
}
