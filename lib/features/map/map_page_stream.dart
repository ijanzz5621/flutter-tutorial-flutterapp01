import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'map_handler.dart';

class MapPageStream extends StatefulWidget {
  const MapPageStream({super.key});

  @override
  State<MapPageStream> createState() => _MapPageStreamState();
}

class _MapPageStreamState extends State<MapPageStream> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  Marker? _userLocationMarker;
  bool _isLoadingLocation = true;
  String? _locationError;
  late MapHandler _mapHandler;

  @override
  void initState() {
    super.initState();
    _mapHandler = MapHandler(
      mapController: _controller,
      onLocationUpdate: (position) {
        setState(() {
          _currentPosition = position;
        });
      },
      onError: (message) {
        setState(() {
          _locationError = message;
        });
        _showSnackbar(message, isError: true);
      },
      onMarkerUpdate: (marker) {
        setState(() {
          _userLocationMarker = marker;
        });
      },
      onLoadingStateChange: (loading) {
        setState(() {
          _isLoadingLocation = loading;
        });
      },
    );

    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _mapHandler.loadCustomIcon('assets/images/person-marker-icon.png');
    await _mapHandler.startLocationUpdates();
  }

  @override
  void dispose() {
    _mapHandler.dispose();
    super.dispose();
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Colors.red : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Track',
        child: const Icon(Icons.directions_walk),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoadingLocation) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_locationError != null) {
      return _buildErrorUI(_locationError!);
    }

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition ?? const LatLng(4.2105, 101.9758),
        zoom: 18.0,
      ),
      mapType: MapType.normal,
      onMapCreated: (controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      markers: _userLocationMarker != null ? {_userLocationMarker!} : {},
      zoomControlsEnabled: false,
      mapToolbarEnabled: true,
      trafficEnabled: true,
    );
  }

  Widget _buildErrorUI(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 60,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 20),
            Text(
              'Failed to Retrieve Location',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: () => _initializeMap(),
              label: const Text('Retry'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _locationError = null;
                  _currentPosition = null;
                });
              },
              child: const Text('Show Default Map'),
            ),
          ],
        ),
      ),
    );
  }
}
