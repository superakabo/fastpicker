import 'package:fastpicker/src/extensions/asset_path_entity_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGridView extends HookWidget {
  final AnimationController controller;
  final ScrollPhysics? physics;
  final ValueNotifier<AssetPathEntity> selectedAlbumRef;

  const MediaGridView({
    required this.controller,
    required this.selectedAlbumRef,
    this.physics,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final album = useListenable(selectedAlbumRef).value;
    final mediaCache = useMemoized(() => album.assetEntities, [album]);
    final media = useFuture(mediaCache, initialData: <AssetEntity>[]).data;

    return GridView.builder(
      physics: physics,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
      itemCount: media?.length ?? 0,
      itemBuilder: (context, index) {
        return AssetEntityImage(
          key: UniqueKey(),
          media![index],
          isOriginal: false,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
