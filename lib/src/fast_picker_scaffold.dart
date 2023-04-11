import 'package:fastpicker/src/album_list_view.dart';
import 'package:fastpicker/src/extensions/asset_path_entity_extension.dart';
import 'package:fastpicker/src/limited_permission_banner.dart';
import 'package:fastpicker/src/permission_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_manager/photo_manager.dart';

import 'fast_picker_toolbar.dart';
import 'media_grid_view.dart';
import 'models/album_model.dart';
import 'muti_select_banner.dart';
import 'utilities/strings.dart';

class FastPickerScaffold extends HookWidget {
  final Strings strings;
  final int maxSelection;
  final ScrollPhysics? physics;
  final List<AssetEntity> selectedAssets;
  final void Function(List<AssetEntity>)? onComplete;

  const FastPickerScaffold({
    required this.strings,
    required this.maxSelection,
    required this.selectedAssets,
    required this.onComplete,
    required this.physics,
    super.key,
  }) : assert(maxSelection > 0, 'max selection must be greater than or equal to 1');

  @override
  Widget build(BuildContext context) {
    const duration = Duration(milliseconds: 250);
    const reverseDuration = Duration(milliseconds: 200);

    final albumsRef = useValueNotifier(<AlbumModel>[]);
    final selectedAlbumRef = useValueNotifier(AlbumModel());
    final selectedMediaRef = useValueNotifier(List.of(selectedAssets));

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

    /// Mark: load photos and videos in albums
    Future<void> loadAlbums() async {
      // TODO: filter out empty albums when this issue is resolved
      // https://github.com/fluttercandies/flutter_photo_manager/issues/910

      albumsRef.value.clear();
      final assetPathEntities = await PhotoManager.getAssetPathList();

      for (var assetPathEntity in assetPathEntities) {
        albumsRef.value.add(AlbumModel.raw(
          id: assetPathEntity.id,
          name: assetPathEntity.name,
          albumType: assetPathEntity.albumType,
          lastModified: assetPathEntity.lastModified,
          type: assetPathEntity.type,
          thumbnail: await assetPathEntity.thumbnail,
          assets: await assetPathEntity.assetEntities,
          assetCount: await assetPathEntity.assetCountAsync,
        ));

        if (assetPathEntity.id == selectedAlbumRef.value.id) {
          selectedAlbumRef.value = selectedAlbumRef.value;
        } else {
          selectedAlbumRef.value = albumsRef.value.first;
        }
      }

      albumsRef.value = List.of(albumsRef.value);
    }

    useEffect(() {
      if (hasPermission) loadAlbums();
      return;
    }, [hasPermission]);

    /// Mark: show permission state message
    useEffect(() {
      switch (permission) {
        case PermissionState.limited:
          permissionLimitedController.forward();
          break;

        case PermissionState.denied:
        case PermissionState.restricted:
          permissionController.forward();
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

    /// Mark: clear selected media assets when
    /// multi-select mode is turned-off.
    useEffect(() {
      void callback(AnimationStatus status) {
        if (status == AnimationStatus.reverse) {
          selectedMediaRef.value = [];
        }
      }

      multiSelectController.addStatusListener(callback);
      return () => multiSelectController.removeStatusListener(callback);
    }, const []);

    /// Mark: monitor changes in albums and update the
    /// media assets within them.
    useEffect(() {
      if (hasPermission) {
        void callback(_) => loadAlbums();
        PhotoManager.addChangeCallback(callback);
        PhotoManager.startChangeNotify();
        return () {
          PhotoManager.removeChangeCallback(callback);
          PhotoManager.stopChangeNotify();
        };
      }
      return null;
    }, [hasPermission]);

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
                  selectedMediaRef: selectedMediaRef,
                  maxSelection: maxSelection,
                  onComplete: onComplete,
                  physics: physics,
                  strings: strings,
                ),
                AlbumListView(
                  albumsRef: albumsRef,
                  selectedAlbumRef: selectedAlbumRef,
                  controller: albumController,
                  physics: physics,
                ),
              ],
            ),
          ),
          MultiSelectBanner(
            strings: strings,
            controller: multiSelectController,
            selectedMediaRef: selectedMediaRef,
            onComplete: onComplete,
            physics: physics,
          ),
        ],
      ),
      bottomSheet: PermissionBottomSheet(
        strings: strings,
        permission: permission,
        controller: permissionController,
      ),
    );
  }
}
