import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:http/retry.dart';
import 'package:maplibre/src/platform/dart/tile_cache.dart';

/// Base tile provider class. [TileProvider]s are used to fetch tiles.
// ignore: one_member_abstracts
abstract class TileProvider {
  /// Create a new [TileProvider] instance.
  const TileProvider();

  /// Get the byte data for a zoom level, and x/y position.
  Future<Uint8List> getTile({
    required int z,
    required int x,
    required int y,
  });
}

/// A [TileProvider] that fetches tiles from the web.
class HttpTileProvider extends TileProvider {
  /// Create a new [HttpTileProvider] instance.
  HttpTileProvider({required this.urlTemplate});

  /// The source url.
  final String urlTemplate;

  final _regex = RegExp('{([^{}]*)}');
  final _client = RetryClient(Client());

  @override
  Future<Uint8List> getTile({
    required int z,
    required int x,
    required int y,
  }) async {
    final uri  =_getUri(z: z, x: x, y: y);
    final cache = TileCache.get.getTile(uri.toString());
    if (cache != null) return cache;
    final response = await _client.get(uri);
    return response.bodyBytes;
  }

  Uri _getUri({required int z, required int x, required int y}) {
    final replaced = urlTemplate.replaceAllMapped(
      _regex,
      (match) {
        return switch (match.group(1)) {
          'z' => z.toString(),
          'x' => x.toString(),
          'y' => y.toString(),
          _ => match.group(1) ?? '',
        };
      },
    );
    return Uri.parse(replaced);
  }
}
