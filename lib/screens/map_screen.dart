import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:provider/provider.dart';
import 'package:svitlo/models/point_item.dart';
import 'package:svitlo/providers/points_provider.dart';

import '../helpers/tile_servers.dart';

class MapScreen extends StatefulWidget {
  static const String routeName = '/map';
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  static const defaultPos = LatLng(49.55, 25.59);
  final controller = MapController(
    location: defaultPos,
  );

  void _gotoDefault() {
    controller.center = const LatLng(35.68, 51.41);
    setState(() {});
  }

  void _onDoubleTap(MapTransformer transformer, Offset position) {
    const delta = 0.5;
    final zoom = (controller.zoom + delta).clamp(2, 18).toDouble();

    transformer.setZoomInPlace(zoom, position);
    setState(() {});
  }

  Offset? _dragStart;
  double _scaleStart = 1.0;
  void _onScaleStart(ScaleStartDetails details) {
    _dragStart = details.focalPoint;
    _scaleStart = 1.0;
  }

  void _onScaleUpdate(ScaleUpdateDetails details, MapTransformer transformer) {
    final scaleDiff = details.scale - _scaleStart;
    _scaleStart = details.scale;

    if (scaleDiff > 0) {
      controller.zoom += 0.02;
      setState(() {});
    } else if (scaleDiff < 0) {
      controller.zoom -= 0.02;
      setState(() {});
    } else {
      final now = details.focalPoint;
      final diff = now - _dragStart!;
      _dragStart = now;
      transformer.drag(diff.dx, diff.dy);
      setState(() {});
    }
  }

  Widget _buildMarkerWidget(MapTransformer transformer, PointItem pointItem, double size, [IconData icon = Icons.location_on]) {
    final pos = transformer.toOffset(pointItem.pos);
    return Positioned(
      left: pos.dx - size / 2,
      top: pos.dy - size / 2,
      width: size,
      height: size,
      child: GestureDetector(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: pointItem.active ? Colors.amber : Colors.black,
            border: Border.all(),
          ),
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Text(pointItem.hostName),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<PointItem> points = Provider.of<PointsProvider>(context, listen: false).points;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Markers'),
      ),
      body: MapLayout(
        controller: controller,
        builder: (context, transformer) {
          // final activeLights = points.where((element) => element.active).map((e) => e.pos).map(transformer.toOffset).toList();
          // final inactiveLights = points.where((element) => !element.active).map((e) => e.pos).map(transformer.toOffset).toList();

          final markers = points.map(
            (pos) => _buildMarkerWidget(transformer, pos, 16, Icons.circle),
          );
          // final inactiveWidgets = inactiveLights.map(
          //   (pos) => _buildMarkerWidget(pos, Colors.black, 16, Icons.circle),
          // );

          // final homeLocation = transformer.toOffset(const LatLng(35.68, 51.42));

          // final homeMarkerWidget = _buildMarkerWidget(homeLocation, Colors.black, Icons.home);

          // final centerLocation = Offset(transformer.constraints.biggest.width / 2, transformer.constraints.biggest.height / 2);

          // final centerMarkerWidget = _buildMarkerWidget(centerLocation, Colors.purple);

          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            onDoubleTapDown: (details) => _onDoubleTap(
              transformer,
              details.localPosition,
            ),
            onScaleStart: _onScaleStart,
            onScaleUpdate: (details) => _onScaleUpdate(details, transformer),
            child: Listener(
              behavior: HitTestBehavior.opaque,
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final delta = event.scrollDelta.dy / -1000.0;
                  final zoom = (controller.zoom + delta).clamp(2, 18).toDouble();

                  transformer.setZoomInPlace(zoom, event.localPosition);
                  setState(() {});
                }
              },
              child: Stack(
                children: [
                  TileLayer(
                    builder: (context, x, y, z) {
                      final tilesInZoom = pow(2.0, z).floor();

                      while (x < 0) {
                        x += tilesInZoom;
                      }
                      while (y < 0) {
                        y += tilesInZoom;
                      }

                      x %= tilesInZoom;
                      y %= tilesInZoom;

                      return CachedNetworkImage(
                        imageUrl: mapbox(z, x, y),
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                  // homeMarkerWidget,
                  ...markers,
                  // centerMarkerWidget,
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _gotoDefault,
        tooltip: 'My Location',
        child: const Icon(Icons.my_location),
      ),
    );
  }
}
