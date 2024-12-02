import 'dart:isolate';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Theme;
import 'package:flutter/rendering.dart';
import 'package:maplibre/maplibre.dart';
import 'package:maplibre/src/map_state.dart';
import 'package:maplibre/src/platform/dart/map_grid_view.dart';
import 'package:maplibre/src/platform/dart/style.dart';
import 'package:maplibre/src/platform/dart/tile_painter.dart';
import 'package:maplibre/src/platform/dart/tile_provider.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

/// An platform invariant implementation of the [MapLibreMap] widget.
final class MapLibreMapStateDart extends MapLibreMapState {
  @override
  Widget buildPlatformWidget(BuildContext context) {
    final theme = ThemeReader().read(demoStyle);
    const tileSize = 256;
    const z = 3;

    debugRepaintRainbowEnabled = true;
    final child = MapGridView(
      tileSize: tileSize,
      delegate: TwoDimensionalChildBuilderDelegate(
        maxXIndex: 1000,
        maxYIndex: 1000,
        builder: (context, vicinity) {
          return FutureBuilder<ui.Image>(
            future: _loadTileImage(theme, vicinity.xIndex, vicinity.yIndex, z, 2),
            builder: (context, snapshot) {
              if (snapshot.data case final ui.Image image) {
                return CustomPaint(
                  size: Size.square(tileSize.toDouble()),
                  painter: TileImagePainter(
                    image: image,
                    scale: 0.5,
                  ),
                );
              }
              if (snapshot.hasError) {
                debugPrint(snapshot.error?.toString());
              }
              return const SizedBox.expand();
            },
          );
          /*return FutureBuilder<Tileset>(
            future: _loadTileset(theme, vicinity.xIndex, vicinity.yIndex, z),
            builder: (context, snapshot) {
              if (snapshot.data case final Tileset tileset) {
                return CustomPaint(
                  size: Size.square(tileSize.toDouble()),
                  painter: TilePainter(
                    tileset: tileset,
                    theme: theme,
                    zoom: z.toDouble(),
                    rotation: 0,
                    scale: 1,
                  ),
                );
              }
              if (snapshot.hasError) {
                debugPrint(snapshot.error?.toString());
              }
              return const SizedBox.expand();
            },
          );*/
        },
      ),
    );
    // return child;
    return child;
  }

  Future<ui.Image> _loadTileImage(
    Theme theme,
    int x,
    int y,
    int z,
    double scale,
  ) async {
    final tileset = await _loadTileset(theme, x, y, z);
    return ImageRenderer(theme: theme, scale: scale).render(
      TileSource(tileset: tileset),
      zoom: z.toDouble(),
      zoomScaleFactor: pow(2, scale).toDouble(),
    );
  }

  @override
  Future<void> addImage(String id, Uint8List bytes) {
    // TODO: implement addImage
    throw UnimplementedError();
  }

  @override
  Future<void> addLayer(StyleLayer layer, {String? belowLayerId}) {
    // TODO: implement addLayer
    throw UnimplementedError();
  }

  @override
  Future<void> addSource(Source source) {
    // TODO: implement addSource
    throw UnimplementedError();
  }

  @override
  Future<void> animateCamera({
    Position? center,
    double? zoom,
    double? bearing,
    double? pitch,
    Duration nativeDuration = const Duration(seconds: 2),
    double webSpeed = 1.2,
    Duration? webMaxDuration,
  }) {
    // TODO: implement animateCamera
    throw UnimplementedError();
  }

  Future<Tileset> _loadTileset(Theme theme, int x, int y, int z) async {
    const url = 'https://demotiles.maplibre.org/tiles/{z}/{x}/{y}.pbf';
    final provider = HttpTileProvider(urlTemplate: url);
    final tileBytes = await provider.getTile(z: z, x: x, y: y);
    final tile = TileFactory(theme, const Logger.noop())
        .createTileData(VectorTileReader().read(tileBytes))
        .toTile();
    final tileset = TilesetPreprocessor(theme)
        .preprocess(Tileset({'maplibre': tile}), zoom: z.toDouble());
    return tileset;
  }

  @override
  Future<void> enableLocation({
    Duration fastestInterval = const Duration(milliseconds: 750),
    Duration maxWaitTime = const Duration(seconds: 1),
    bool pulseFade = true,
    bool accuracyAnimation = true,
    bool compassAnimation = true,
    bool pulse = true,
  }) {
    // TODO: implement enableLocation
    throw UnimplementedError();
  }

  @override
  Future<void> fitBounds({
    required LngLatBounds bounds,
    double? bearing,
    double? pitch,
    Duration nativeDuration = const Duration(seconds: 2),
    double webSpeed = 1.2,
    Duration? webMaxDuration,
    Offset offset = Offset.zero,
    double webMaxZoom = double.maxFinite,
    bool webLinear = false,
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    // TODO: implement fitBounds
    throw UnimplementedError();
  }

  @override
  Future<List<String>> getAttributions() {
    // TODO: implement getAttributions
    throw UnimplementedError();
  }

  @override
  MapCamera getCamera() {
    // TODO: implement getCamera
    throw UnimplementedError();
  }

  @override
  Future<double> getMetersPerPixelAtLatitude(double latitude) {
    // TODO: implement getMetersPerPixelAtLatitude
    throw UnimplementedError();
  }

  @override
  double getMetersPerPixelAtLatitudeSync(double latitude) {
    // TODO: implement getMetersPerPixelAtLatitudeSync
    throw UnimplementedError();
  }

  @override
  Future<LngLatBounds> getVisibleRegion() {
    // TODO: implement getVisibleRegion
    throw UnimplementedError();
  }

  @override
  LngLatBounds getVisibleRegionSync() {
    // TODO: implement getVisibleRegionSync
    throw UnimplementedError();
  }

  @override
  Future<void> moveCamera({
    Position? center,
    double? zoom,
    double? bearing,
    double? pitch,
  }) {
    // TODO: implement moveCamera
    throw UnimplementedError();
  }

  @override
  Future<List<QueriedLayer>> queryLayers(Offset screenLocation) {
    // TODO: implement queryLayers
    throw UnimplementedError();
  }

  @override
  Future<void> removeImage(String id) {
    // TODO: implement removeImage
    throw UnimplementedError();
  }

  @override
  Future<void> removeLayer(String id) {
    // TODO: implement removeLayer
    throw UnimplementedError();
  }

  @override
  Future<void> removeSource(String id) {
    // TODO: implement removeSource
    throw UnimplementedError();
  }

  @override
  Future<Position> toLngLat(Offset screenLocation) {
    // TODO: implement toLngLat
    throw UnimplementedError();
  }

  @override
  Position toLngLatSync(Offset screenLocation) {
    // TODO: implement toLngLatSync
    throw UnimplementedError();
  }

  @override
  Future<List<Position>> toLngLats(List<Offset> screenLocations) {
    // TODO: implement toLngLats
    throw UnimplementedError();
  }

  @override
  List<Position> toLngLatsSync(List<Offset> screenLocations) {
    // TODO: implement toLngLatsSync
    throw UnimplementedError();
  }

  @override
  Future<Offset> toScreenLocation(Position lngLat) {
    // TODO: implement toScreenLocation
    throw UnimplementedError();
  }

  @override
  Offset toScreenLocationSync(Position lngLat) {
    // TODO: implement toScreenLocationSync
    throw UnimplementedError();
  }

  @override
  Future<List<Offset>> toScreenLocations(List<Position> lngLats) {
    // TODO: implement toScreenLocations
    throw UnimplementedError();
  }

  @override
  List<Offset> toScreenLocationsSync(List<Position> lngLats) {
    // TODO: implement toScreenLocationsSync
    throw UnimplementedError();
  }

  @override
  Future<void> trackLocation({
    bool trackLocation = true,
    BearingTrackMode trackBearing = BearingTrackMode.gps,
  }) {
    // TODO: implement trackLocation
    throw UnimplementedError();
  }

  @override
  Future<void> updateGeoJsonSource({required String id, required String data}) {
    // TODO: implement updateGeoJsonSource
    throw UnimplementedError();
  }
}
