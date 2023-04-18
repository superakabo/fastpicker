import 'package:fastpicker/src/utilities/enums/loading_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/album_model.dart';
import 'utilities/fast_picker_strings.dart';

class AlbumDrawerButton extends StatelessWidget {
  final AnimationController controller;
  final ValueNotifier<AlbumModel> selectedAlbumRef;
  final ValueNotifier<LoadingStatus> loadingStatusRef;
  final FastPickerStrings strings;

  const AlbumDrawerButton({
    required this.controller,
    required this.selectedAlbumRef,
    required this.loadingStatusRef,
    required this.strings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return Semantics(
          button: true,
          toggled: (controller.value == 1),
          label: strings.toggleAlbumDrawer,
          child: child,
        );
      },
      child: SizedBox(
        height: 44,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Material(
            color: theme.colorScheme.tertiaryContainer.withOpacity(0.3),
            shape: const StadiumBorder(),
            child: InkWell(
              customBorder: const StadiumBorder(),
              onTap: () {
                if (selectedAlbumRef.value.name.isNotEmpty) {
                  if (controller.status == AnimationStatus.dismissed) {
                    controller.forward();
                  } else if (controller.status == AnimationStatus.completed) {
                    controller.reverse();
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ValueListenableBuilder<LoadingStatus>(
                  valueListenable: loadingStatusRef,
                  builder: (context, loadingStatus, _) {
                    return _DrawerButtonChild(
                      controller: controller,
                      loadingStatus: loadingStatus,
                      selectedAlbumRef: selectedAlbumRef,
                      strings: strings,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DrawerButtonChild extends StatelessWidget {
  final LoadingStatus loadingStatus;
  final FastPickerStrings strings;
  final ValueNotifier<AlbumModel> selectedAlbumRef;
  final AnimationController controller;

  const _DrawerButtonChild({
    required this.loadingStatus,
    required this.selectedAlbumRef,
    required this.strings,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder<AlbumModel>(
      valueListenable: selectedAlbumRef,
      builder: (context, album, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 4, right: 8),
              child: Text(
                (loadingStatus == LoadingStatus.complete) ? album.name : strings.loading,
                textScaleFactor: 1,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (loadingStatus == LoadingStatus.complete)
              DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.colorScheme.tertiaryContainer,
                ),
                child: RotationTransition(
                  turns: Tween<double>(begin: 0.0, end: 0.5).animate(controller),
                  child: const Icon(Icons.expand_more, size: 20),
                ),
              )
            else
              const CupertinoActivityIndicator(radius: 8)
          ],
        );
      },
    );
  }
}
