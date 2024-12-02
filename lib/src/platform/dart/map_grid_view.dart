import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

/// Internal tile grid that uses Flutters' [TwoDimensionalScrollView].
class MapGridView extends TwoDimensionalScrollView {
  /// Create a new [MapGridView] instance.
  const MapGridView({
    required TwoDimensionalChildBuilderDelegate delegate,
    required this.tileSize,
    super.key,
  }) : super(
          delegate: delegate,
          cacheExtent: 300,
          diagonalDragBehavior: DiagonalDragBehavior.free,
        );

  /// Tile size
  final int tileSize;

  @override
  Widget buildViewport(
    BuildContext context,
    ViewportOffset verticalOffset,
    ViewportOffset horizontalOffset,
  ) {
    return _MapGridViewport(
      horizontalOffset: horizontalOffset,
      verticalOffset: verticalOffset,
      horizontalAxisDirection: horizontalDetails.direction,
      verticalAxisDirection: verticalDetails.direction,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      tileSize: tileSize,
    );
  }
}

class _MapGridViewport extends TwoDimensionalViewport {
  const _MapGridViewport({
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required TwoDimensionalChildBuilderDelegate super.delegate,
    required super.mainAxis,
    required this.tileSize,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  });

  final int tileSize;

  @override
  RenderTwoDimensionalViewport createRenderObject(BuildContext context) {
    return _RenderMapGridViewport(
      horizontalOffset: horizontalOffset,
      horizontalAxisDirection: horizontalAxisDirection,
      verticalOffset: verticalOffset,
      verticalAxisDirection: verticalAxisDirection,
      mainAxis: mainAxis,
      delegate: delegate as TwoDimensionalChildBuilderDelegate,
      childManager: context as TwoDimensionalChildManager,
      cacheExtent: cacheExtent,
      clipBehavior: clipBehavior,
      tileSize: tileSize,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderMapGridViewport renderObject,
  ) {
    renderObject
      ..horizontalOffset = horizontalOffset
      ..horizontalAxisDirection = horizontalAxisDirection
      ..verticalOffset = verticalOffset
      ..verticalAxisDirection = verticalAxisDirection
      ..mainAxis = mainAxis
      ..delegate = delegate
      ..cacheExtent = cacheExtent
      ..clipBehavior = clipBehavior;
  }
}

class _RenderMapGridViewport extends RenderTwoDimensionalViewport {
  _RenderMapGridViewport({
    required super.horizontalOffset,
    required super.horizontalAxisDirection,
    required super.verticalOffset,
    required super.verticalAxisDirection,
    required TwoDimensionalChildBuilderDelegate delegate,
    required super.mainAxis,
    required super.childManager,
    required this.tileSize,
    super.cacheExtent,
    super.clipBehavior = Clip.hardEdge,
  }) : super(delegate: delegate);

  final int tileSize;

  @override
  void layoutChildSequence() {
    final horizontalPixels = horizontalOffset.pixels;
    final verticalPixels = verticalOffset.pixels;
    final viewportWidth = viewportDimension.width + cacheExtent;
    final viewportHeight = viewportDimension.height + cacheExtent;
    final builderDelegate = delegate as TwoDimensionalChildBuilderDelegate;

    final maxRowIndex = builderDelegate.maxYIndex!;
    final maxColumnIndex = builderDelegate.maxXIndex!;

    final int leadingColumn =
        math.max((horizontalPixels / tileSize).floor(), 0);
    final int leadingRow = math.max((verticalPixels / tileSize).floor(), 0);
    final int trailingColumn = math.min(
      ((horizontalPixels + viewportWidth) / tileSize).ceil(),
      maxColumnIndex,
    );
    final int trailingRow = math.min(
      ((verticalPixels + viewportHeight) / tileSize).ceil(),
      maxRowIndex,
    );

    var xLayoutOffset = (leadingColumn * tileSize) - horizontalOffset.pixels;
    for (var column = leadingColumn; column <= trailingColumn; column++) {
      var yLayoutOffset = (leadingRow * tileSize) - verticalOffset.pixels;
      for (var row = leadingRow; row <= trailingRow; row++) {
        final vicinity = ChildVicinity(xIndex: column, yIndex: row);
        final child = buildOrObtainChildFor(vicinity)!;
        child.layout(constraints.loosen());

        // Subclasses only need to set the normalized layout offset. The super
        // class adjusts for reversed axes.
        parentDataOf(child).layoutOffset = Offset(xLayoutOffset, yLayoutOffset);
        yLayoutOffset += tileSize;
      }
      xLayoutOffset += tileSize;
    }

    // Set the min and max scroll extents for each axis.
    final verticalExtent = tileSize * (maxRowIndex + 1);
    verticalOffset.applyContentDimensions(
      0,
      clampDouble(
        verticalExtent - viewportDimension.height,
        0,
        double.infinity,
      ),
    );
    final horizontalExtent = tileSize * (maxColumnIndex + 1);
    horizontalOffset.applyContentDimensions(
      0,
      clampDouble(
        horizontalExtent - viewportDimension.width,
        0,
        double.infinity,
      ),
    );
    // Super class handles garbage collection
  }
}
