import 'dart:typed_data';

/// The tile manager handles all tiles.
class TileCache {
  TileCache._();

  static TileCache? _instance;

  /// Get the global [TileCache] instance.
  // ignore: prefer_constructors_over_static_methods
  static TileCache get get => _instance ??= TileCache._();

  final _cache = <String, Uint8List>{};

  /// Get the tile bytes from the cache.
  Uint8List? getTile(String key) => _cache[key];

  /// Add or update the cached bytes for a given key.
  void putTile(String key, Uint8List data) => _cache[key] = data;
}
