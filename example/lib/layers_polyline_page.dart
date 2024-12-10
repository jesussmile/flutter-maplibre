import 'package:flutter/material.dart';
import 'package:maplibre/maplibre.dart';

@immutable
class LayersPolylinePage extends StatefulWidget {
  const LayersPolylinePage({super.key});

  static const location = '/layers/polyline';

  @override
  State<LayersPolylinePage> createState() => _LayersPolylinePageState();
}

class _LayersPolylinePageState extends State<LayersPolylinePage> {
  final _polylines = <LineString>[
    LineString(
      const [
        Geographic(lon: 9.17, lat: 47.68),
        Geographic(lon: 9.5, lat: 48),
        Geographic(lon: 9, lat: 48),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Polyline Layers')),
      body: MapLibreMap(
        options: const MapOptions(
          initZoom: 7,
          initCenter: Geographic(lon: 9.17, lat: 47.68),
        ),
        onEvent: (event) {
          if (event case MapEventClick()) {
            setState(() {
              _polylines.first.coordinates.add(event.point);
            });
          }
        },
        layers: [
          PolylineLayer(
            polylines: _polylines,
            color: Colors.red,
            width: 4,
            blur: 3,
            dashArray: const [5, 5],
          ),
        ],
      ),
    );
  }
}
