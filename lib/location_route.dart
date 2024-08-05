import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class LocationRoute extends StatefulWidget {
  @override
  _LocationRouteState createState() => _LocationRouteState();
}

class _LocationRouteState extends State<LocationRoute> {
  LatLng _startLocation = LatLng(51.5, -0.09);
  LatLng? _endLocation;
  List<LatLng> _routePoints = [];
  double? _drivingDistance;
  bool _isStartSelected = false;
  bool _isEndSelected = false;

  void _onMapTapped(LatLng point) {
    setState(() {
      if (!_isStartSelected) {
        _startLocation = point;
        _isStartSelected = true;
        print('Start location set to: $_startLocation');
      } else if (!_isEndSelected) {
        _endLocation = point;
        _isEndSelected = true;
        print('End location set to: $_endLocation');
      }
    });
  }

  Future<void> _getRoute() async {
    if (_endLocation == null) return;

    final url =
        'http://router.project-osrm.org/route/v1/driving/${_startLocation.longitude},${_startLocation.latitude};${_endLocation!.longitude},${_endLocation!.latitude}?overview=full&geometries=geojson';
    print('Fetching route from: $url');

    try {
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final route = json['routes'][0];
        final coordinates = route['geometry']['coordinates'];
        final distance = route['distance'] / 1000.0; // Distance in kilometers

        setState(() {
          _routePoints = coordinates
              .map<LatLng>((point) => LatLng(point[1], point[0]))
              .toList();
          _drivingDistance = distance;
        });

        print('Driving distance: ${_drivingDistance!.toStringAsFixed(2)} km');
      } else {
        print('Failed to load route, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
    }
  }

  void _onConfirmPressed() {
    if (_isStartSelected && _isEndSelected) {
      _getRoute();
    } else {
      print('Please select both start and end locations');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(
                center: _startLocation,
                zoom: 13.0,
                onTap: (tapPosition, latLng) => _onMapTapped(latLng),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _startLocation,
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 40.0,
                        ),
                      ),
                    ),
                    if (_endLocation != null)
                      Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _endLocation!,
                        builder: (ctx) => Container(
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40.0,
                          ),
                        ),
                      ),
                  ],
                ),
                if (_routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: _routePoints,
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _onConfirmPressed,
            child: Text('Confirm Route'),
          ),
        ],
      ),
    );
  }
}
