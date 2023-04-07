import 'package:photo_manager/photo_manager.dart';

extension AssetPathEntityExtension on AssetPathEntity {
  Future<AssetEntity> get thumbnail async {
    final assetEntities = await getAssetListRange(start: 0, end: 1);
    return assetEntities.first;
  }

  Future<List<AssetEntity>> get assetEntities async {
    final count = await assetCountAsync;
    return await getAssetListRange(start: 0, end: count);
  }
}
