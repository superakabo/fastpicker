import 'package:photo_manager/photo_manager.dart';

extension AssetPathEntityExtension on AssetPathEntity {
  Future<AssetEntity?> get thumbnail async {
    final assetEntities = await getAssetListRange(start: 0, end: 1);
    return (assetEntities.isEmpty) ? null : assetEntities.first;
  }

  Future<List<AssetEntity>> get assetEntities async {
    final count = await assetCountAsync;
    return (count == 0) ? [] : await getAssetListRange(start: 0, end: count);
  }

  Future<List<AssetEntity>> toAssetEntities(List<String> ids) async {
    final assetEntities = <AssetEntity>[];
    await Future.forEach(ids, (id) async {
      final tmp = await AssetEntity.fromId(id);
      final exists = (await tmp?.exists) ?? false;
      if (exists) assetEntities.add(tmp!);
    });
    return assetEntities;
  }
}
