import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

import 'linear_sheet.dart';
import 'utilities/strings.dart';

class LimitedPermissionBanner extends StatelessWidget {
  final Strings strings;
  final AnimationController controller;

  const LimitedPermissionBanner({
    required this.controller,
    required this.strings,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LinearSheet(
      controller: controller,
      begin: const Offset(0, -1),
      end: const Offset(0, 0),
      alignment: AlignmentDirectional.topStart,
      animationAlignment: AlignmentDirectional.bottomStart,
      child: ColoredBox(
        color: theme.colorScheme.tertiaryContainer.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 6,
            left: 16,
            bottom: 6,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  strings.limitedPermissionMessage,
                ),
              ),
              TextButton(
                child: Text(strings.manage),
                onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) {
                    return CupertinoActionSheet(
                      message: Text(strings.manageAccessToYourPhotosAndVideos),
                      actions: [
                        CupertinoActionSheetAction(
                          onPressed: PhotoManager.presentLimited,
                          child: Text(strings.selectMorePhotos),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: PhotoManager.openSetting,
                          child: Text(strings.changeSettings),
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        onPressed: Navigator.of(context).pop,
                        child: Text(strings.cancel),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
