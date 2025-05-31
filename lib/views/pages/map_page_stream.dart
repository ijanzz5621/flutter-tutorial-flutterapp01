import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPageStream extends StatefulWidget {
  const MapPageStream({super.key});

  @override
  State<MapPageStream> createState() => _MapPageStreamState();
}

class _MapPageStreamState extends State<MapPageStream> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  bool _isLoadingLocation = true;
  String? _locationAcquisitionError;

  // Stream subscription to listen for continuous location updates
  StreamSubscription<Position>? _positionStreamSubscription;

  // Initial camera position (e.g., center of Malaysia)
  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.2105, 101.9758), // Center of Malaysia
    zoom: 7.0,
  );

  // Example "lake" position for the FAB
  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  void initState() {
    super.initState();
    _startLocationUpdates(); // Start listening for location updates
  }

  @override
  void dispose() {
    _positionStreamSubscription
        ?.cancel(); // Cancel the stream to prevent memory leaks
    super.dispose();
  }

  // Helper to show SnackBars
  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).removeCurrentSnackBar(); // Remove previous snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Ensures location services are enabled and permissions are granted.
  // Throws an Exception if checks fail.
  Future<void> _ensureLocationPermissions() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled. Please enable them.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permissions were denied. Please grant them to use this feature.',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable them in app settings.',
      );
    }
  }

  // Starts listening for continuous location updates
  Future<void> _startLocationUpdates() async {
    setState(() {
      _isLoadingLocation = true;
      _locationAcquisitionError = null;
    });

    try {
      await _ensureLocationPermissions();

      // Define location settings for continuous updates
      // This is crucial for performance:
      // - accuracy: high for precise tracking
      // - distanceFilter: only get updates if moved by 10 meters (adjust as needed)
      // - timeInterval: minimum time between updates (optional, useful with distanceFilter)
      LocationSettings locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters
        // timeInterval: 5000, // milliseconds (e.g., minimum 5 seconds between updates)
      );

      _positionStreamSubscription =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            (Position position) async {
              debugPrint(
                'Location Update: ${position.latitude}, ${position.longitude}',
              );
              setState(() {
                _currentPosition = LatLng(
                  position.latitude,
                  position.longitude,
                );
                _isLoadingLocation =
                    false; // Once we get the first position, loading is done
              });

              // Animate camera to current position for a smooth following effect
              if (_controller.isCompleted) {
                final GoogleMapController mapController =
                    await _controller.future;
                // Only animate if the user hasn't manually panned away much,
                // or if you always want it to follow.
                // For continuous following, just animate every time.
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _currentPosition!,
                      zoom: 15.0, // You can adjust the zoom level
                    ),
                  ),
                );
              }
            },
            onError: (e) {
              String errorMessage = e.toString();
              if (e is LocationServiceDisabledException) {
                errorMessage =
                    'Location services disabled. Please enable them.';
              } else if (e is PermissionDeniedException) {
                errorMessage =
                    'Location permissions denied. Please enable them in app settings.';
              }
              debugPrint("Error in location stream: $errorMessage");
              setState(() {
                _locationAcquisitionError = errorMessage;
                _isLoadingLocation = false;
                _currentPosition = null; // Clear position on error
              });
              _showSnackbar(_locationAcquisitionError!, isError: true);
            },
            onDone: () {
              debugPrint("Location stream ended.");
              _showSnackbar("Location tracking stopped.", isError: false);
              _positionStreamSubscription = null; // Clear the subscription
            },
            cancelOnError: true, // Cancel the stream if an error occurs
          );
    } catch (e) {
      String errorMessage = e.toString();
      if (e is Exception && errorMessage.startsWith("Exception: ")) {
        errorMessage = errorMessage.substring("Exception: ".length);
      }
      debugPrint("Initial location setup error: $errorMessage");
      setState(() {
        _locationAcquisitionError = errorMessage;
        _isLoadingLocation = false;
        _currentPosition = null;
      });
      _showSnackbar(_locationAcquisitionError!, isError: true);
    }
  }

  Future<void> _goToTheLake() async {
    if (!_controller.isCompleted) {
      _showSnackbar("Map is not ready yet.", isError: true);
      return;
    }
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToTheLake,
        label: const Text('To the lake!'),
        icon: const Icon(Icons.directions_boat),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoadingLocation) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_locationAcquisitionError != null) {
      return _buildErrorUI(_locationAcquisitionError!);
    }

    // If _currentPosition is null here, it means we couldn't get a location
    // and there's no specific error, or the error was cleared and we want a fallback.
    // In this case, show the map centered on a default location.
    return GoogleMap(
      mapType: MapType.normal,
      // Use the current position if available, otherwise the default Malaysia center
      initialCameraPosition: _currentPosition != null
          ? CameraPosition(
              target: _currentPosition!,
              zoom: 15.0, // Default zoom when tracking current position
            )
          : _kGooglePlex, // Fallback if no current position
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
      // These are crucial for the "blue dot" and "my location" button
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: true,
    );
  }

  Widget _buildErrorUI(String errorMessage) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
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
              onPressed: () {
                // Restart location updates when retry is pressed
                _positionStreamSubscription
                    ?.cancel(); // Cancel any existing stream
                _startLocationUpdates();
              },
              label: const Text('Retry'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Clear error and try to show the default map
                setState(() {
                  _locationAcquisitionError = null;
                  _isLoadingLocation =
                      false; // We are no longer trying to load an initial current location
                  _currentPosition = null; // Ensure no stale position is used
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
