import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Theme;
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

/// [CustomPainter] that uses the vector_tile_renderer package to render vector
/// tiles to the canvas in pure dart.
class TilePainter extends CustomPainter {
  /// Create a new [TilePainter] instance.
  TilePainter({
    required this.tileset,
    required this.theme,
    required this.zoom,
    required this.rotation,
    required this.scale,
  });

  /// The tile set.
  final Tileset tileset;

  /// The theme.
  final Theme theme;

  /// Map zoom level
  final double zoom;

  /// Map rotation
  final double rotation;

  /// Zoom scale
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    Renderer(theme: theme).render(
      canvas,
      TileSource(tileset: tileset),
      clip: Rect.fromLTWH(0, 0, size.width, size.height),
      zoomScaleFactor: pow(2, scale).toDouble(),
      zoom: zoom,
      rotation: rotation,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// [CustomPainter] that uses the vector_tile_renderer package to render vector
/// tiles to the canvas in pure dart.
class TileImagePainter extends CustomPainter {
  /// Create a new [TilePainter] instance.
  TileImagePainter({
    required this.image,
    required this.scale,
  });

  /// The tile set.
  final ui.Image image;

  /// The scale
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(scale);
    canvas.drawImage(image, Offset.zero, Paint());
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
