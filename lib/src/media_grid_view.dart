import 'package:fastpicker/src/extensions/asset_path_entity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_manager/photo_manager.dart';

import 'selection_indicator.dart';
import 'video_indicator.dart';

class MediaGridView extends HookWidget {
  final AnimationController controller;
  final ScrollPhysics? physics;
  final ValueNotifier<AssetPathEntity> selectedAlbumRef;
  final ValueNotifier<List<AssetEntity>> selectedMediaRef;

  const MediaGridView({
    required this.controller,
    required this.selectedAlbumRef,
    required this.selectedMediaRef,
    this.physics,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final album = useListenable(selectedAlbumRef).value;
    final mediaCache = useMemoized(() => album.assetEntities, [album]);
    final mediaAssets = useFuture(mediaCache, initialData: <AssetEntity>[]).data;

    return GridView.builder(
      physics: physics,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: mediaAssets?.length ?? 0,
      itemBuilder: (context, index) {
        return _GridRow(
          controller: controller,
          selectedMediaRef: selectedMediaRef,
          mediaAsset: mediaAssets![index],
        );
      },
    );
  }
}

class _GridRow extends StatelessWidget {
  final AssetEntity mediaAsset;
  final AnimationController controller;
  final ValueNotifier<List<AssetEntity>> selectedMediaRef;

  const _GridRow({
    required this.mediaAsset,
    required this.controller,
    required this.selectedMediaRef,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      child: Semantics(
        image: true,
        child: InkWell(
          excludeFromSemantics: true,
          onTap: () {
            if (selectedMediaRef.value.contains(mediaAsset)) {
              selectedMediaRef.value.remove(mediaAsset);
              selectedMediaRef.value = List.of(selectedMediaRef.value);
            } else {
              selectedMediaRef.value = [mediaAsset, ...selectedMediaRef.value];
            }
          },
          child: AssetEntityImage(
            mediaAsset,
            isOriginal: false,
            fit: BoxFit.cover,
          ),
        ),
      ),
      builder: (context, child) {
        return GridTile(
          header: ValueListenableBuilder<List<AssetEntity>>(
            valueListenable: selectedMediaRef,
            builder: (context, selectedMedia, child) {
              return SelectionIndicator(
                visible: controller.value == 1,
                selected: selectedMedia.contains(mediaAsset),
              );
            },
          ),
          footer: VideoIndicator(mediaAsset),
          child: child!,
        );
      },
    );
  }
}
