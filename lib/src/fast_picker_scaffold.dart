import 'package:fastpicker/src/album_list_view.dart';
import 'package:fastpicker/src/limited_permission_banner.dart';
import 'package:fastpicker/src/permission_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_manager/photo_manager.dart';

import 'fast_picker_toolbar.dart';
import 'media_grid_view.dart';
import 'muti_select_banner.dart';
import 'utilities/strings.dart';

class FastPickerScaffold extends HookWidget {
  final Strings strings;
  final int maxSelection;

  const FastPickerScaffold({
    required this.strings,
    required this.maxSelection,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 250);
    const reverseDuration = Duration(milliseconds: 200);
    final selectedAlbumRef = useValueNotifier(AssetPathEntity(id: '', name: ''));

    final multiSelectController = useAnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
    );

    final albumController = useAnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
    );

    final permissionLimitedController = useAnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
    );

    final permissionController = useAnimationController(
      duration: duration,
      reverseDuration: reverseDuration,
    );

    /// Mark: request permission
    final permission = useFuture(
      initialData: PermissionState.notDetermined,
      useMemoized(PhotoManager.requestPermissionExtend),
    ).data;

    final hasPermission = useMemoized(() {
      final isAuthorized = (permission == PermissionState.authorized);
      final isLimited = (permission == PermissionState.limited);
      return (isAuthorized || isLimited);
    }, [permission]);

    /// Mark: load photos and videos
    final albums = useFuture<List<AssetPathEntity>?>(
      useMemoized(() async {
        if (hasPermission) {
          final albums = await PhotoManager.getAssetPathList();
          if (albums.isNotEmpty) selectedAlbumRef.value = albums.first;
          return albums;
        }
        return null;
        // TODO: filter out empty albums when this issue is resolved
        ///  https://github.com/fluttercandies/flutter_photo_manager/issues/910
      }, [hasPermission]),
    );

    /// Mark: show permission state message
    useEffect(() {
      switch (permission) {
        case PermissionState.limited:
          permissionLimitedController
            ..reverse()
            ..forward();
          break;

        case PermissionState.denied:
        case PermissionState.restricted:
          permissionController
            ..reverse()
            ..forward();
          break;

        case PermissionState.authorized:
          permissionLimitedController.reverse();
          permissionController.reverse();
          break;

        default:
          break;
      }
      return;
    }, [permission]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(strings.selectMedia),
        bottom: FastPickerToolbar(
          strings: strings,
          visible: hasPermission,
          selectedAlbumRef: selectedAlbumRef,
          albumController: albumController,
          multiSelectController: multiSelectController,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LimitedPermissionBanner(
            strings: strings,
            controller: permissionLimitedController,
          ),
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MediaGridView(
                  controller: multiSelectController,
                  selectedAlbumRef: selectedAlbumRef,
                ),
                AlbumListView(
                  albums: albums,
                  selectedAlbumRef: selectedAlbumRef,
                  controller: albumController,
                ),
              ],
            ),
          ),
          MultiSelectBanner(
            strings: strings,
            controller: multiSelectController,
          ),
        ],
      ),
      bottomSheet: PermissionBottomSheet(
        permissionController,
      ),
    );
  }
}
