import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHandler {
  final Completer<GoogleMapController> mapController;
  final Function(LatLng) onLocationUpdate;
  final Function(String) onError;
  final Function(Marker?) onMarkerUpdate;
  final Function(bool) onLoadingStateChange;

  StreamSubscription<Position>? _positionStreamSubscription;
  BitmapDescriptor? _customIcon;

  MapHandler({
    required this.mapController,
    required this.onLocationUpdate,
    required this.onError,
    required this.onMarkerUpdate,
    required this.onLoadingStateChange,
  });

  Future<void> loadCustomIcon(String assetPath) async {
    _customIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      assetPath,
    );
  }

  void dispose() {
    _positionStreamSubscription?.cancel();
  }

  Future<void> startLocationUpdates() async {
    onLoadingStateChange(true);

    try {
      await _ensureLocationPermissions();

      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      );

      _positionStreamSubscription =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            (Position position) async {
              final currentLatLng = LatLng(
                position.latitude,
                position.longitude,
              );
              onLocationUpdate(currentLatLng);

              final marker = Marker(
                markerId: const MarkerId('user_location'),
                position: currentLatLng,
                icon: _customIcon ?? BitmapDescriptor.defaultMarker,
                anchor: const Offset(0.5, 0.5),
              );
              onMarkerUpdate(marker);

              if (mapController.isCompleted) {
                final controller = await mapController.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: currentLatLng, zoom: 18.0),
                  ),
                );
              }

              onLoadingStateChange(false);
            },
            onError: (e) {
              _handleStreamError(e);
            },
            cancelOnError: true,
          );
    } catch (e) {
      onError(e.toString().replaceFirst("Exception: ", ""));
      onLoadingStateChange(false);
    }
  }

  Future<void> _ensureLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions were denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }
  }

  void _handleStreamError(Object e) {
    String error = e.toString();
    if (e is LocationServiceDisabledException) {
      error = 'Location services disabled.';
    } else if (e is PermissionDeniedException) {
      error = 'Location permissions denied.';
    }

    onError(error);
    onLoadingStateChange(false);
    onMarkerUpdate(null);
  }
}
