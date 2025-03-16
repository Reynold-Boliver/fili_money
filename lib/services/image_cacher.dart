import 'package:flutter_svg/flutter_svg.dart';

/// Precache a single SVG asset.
/// This function uses the internal [svg.cache] to check if the asset is already cached,
/// and if not, it loads the asset bytes.
Future<void> precacheSvgPicture(String svgPath) async {
  final svgLoader = SvgAssetLoader(svgPath);
  await svg.cache.putIfAbsent(
    svgLoader.cacheKey(null),
        () => svgLoader.loadBytes(null),
  );
}
