import 'package:fastpicker/src/extensions/asset_path_entity_extension.dart';
import 'package:fastpicker/src/linear_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:photo_manager/photo_manager.dart';

class AlbumListView extends HookWidget {
  final AnimationController controller;
  final ScrollPhysics? physics;
  final AsyncSnapshot<List<AssetPathEntity>?> albums;
  final ValueNotifier<AssetPathEntity> selectedAlbumRef;

  const AlbumListView({
    required this.controller,
    required this.albums,
    required this.selectedAlbumRef,
    this.physics,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LinearSheet(
      controller: controller,
      heightFactor: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: ListView.separated(
          physics: physics,
          itemCount: albums.data?.length ?? 0,
          itemBuilder: (context, index) {
            return _AlbumRow(
              album: albums.data![index],
              onTap: (album) {
                selectedAlbumRef.value = album;
                controller.reverse();
              },
            );
          },
          separatorBuilder: (context, index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
            );
          },
        ),
      ),
    );
  }
}

class _AlbumRow extends StatelessWidget {
  final AssetPathEntity album;
  final void Function(AssetPathEntity) onTap;

  const _AlbumRow({
    required this.album,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      leading: AspectRatio(
        aspectRatio: 1,
        child: FutureBuilder<AssetEntity?>(
          future: album.thumbnail,
          builder: (context, snapshot) {
            return (snapshot.hasData)
                ? AssetEntityImage(
                    snapshot.data!,
                    isOriginal: false,
                    fit: BoxFit.cover,
                  )
                : const ColoredBox(color: Colors.grey);
            //TODO: remove [ColoredBox(color: Colors.grey)]
            // after filtering out empty albums
          },
        ),
      ),
      title: Text(album.name),
      subtitle: FutureBuilder(
        initialData: 0,
        future: album.assetCountAsync,
        builder: (context, snapshot) {
          return Text(snapshot.data!.toString());
        },
      ),
      onTap: () => onTap(album),
    );
  }
}
