import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();
  LatLng? _currentPosition;
  bool _isLoadingLocation = true;
  String? _locationAcquisitionError;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.2105, 101.9758), // Center of Malaysia
    zoom: 7.0,
  );

  static const CameraPosition _kLake = CameraPosition(
    bearing: 192.8334901395799,
    target: LatLng(37.43296265331129, -122.08832357078792),
    tilt: 59.440717697143555,
    zoom: 19.151926040649414,
  );

  @override
  void initState() {
    super.initState();
    _requestAndSetCurrentPosition();
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
        throw Exception('Location permissions were denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied. Please enable them in app settings.',
      );
    }
  }

  // Fetches current position and updates the state.
  Future<void> _requestAndSetCurrentPosition() async {
    setState(() {
      _isLoadingLocation = true;
      _locationAcquisitionError = null;
    });

    try {
      await _ensureLocationPermissions();

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoadingLocation = false;
      });

      // Animate camera if map is already created and we have a new position.
      // This is primarily useful if this function is called again (e.g., user presses a 'refresh location' button).
      // For the initial load, initialCameraPosition in GoogleMap widget handles the camera.
      if (_controller.isCompleted && _currentPosition != null) {
        final GoogleMapController mapController = await _controller.future;
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition!, zoom: 15.0),
          ),
        );
      }
    } catch (e) {
      String errorMessage = e.toString();
      // Remove "Exception: " prefix if present for cleaner display
      if (e is Exception && errorMessage.startsWith("Exception: ")) {
        errorMessage = errorMessage.substring("Exception: ".length);
      }
      debugPrint("Error getting location: $errorMessage");
      setState(() {
        _locationAcquisitionError = errorMessage;
        _isLoadingLocation = false;
        // _currentPosition = null; // Optionally clear last known position on error
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

    if (_currentPosition != null) {
      return GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          if (!_controller.isCompleted) {
            _controller.complete(controller);
          }
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      );
    }

    // Fallback: Should ideally not be reached if logic is sound,
    // as either _currentPosition is set, or an error occurs.
    return _buildErrorUI(
      "Location could not be determined due to an unexpected issue.",
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
              onPressed: _requestAndSetCurrentPosition,
              label: const Text('Retry'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                // Show fallback map if user wants to see map anyway
                setState(() {
                  _locationAcquisitionError = null; // Clear error to show map
                  _currentPosition = null; // Ensure we don't use stale data
                  // This will cause _buildBody to render the fallback map scenario next time if _currentPosition is still null
                  // and _isLoading is false and error is null
                });
              },
              child: const Text('Show Default Map'),
            ),
          ],
        ),
      ),
    );
  }

  // This build method for fallback map is an example if you want to use it.
  // The current _buildBody logic leads to _buildErrorUI or GoogleMap with _currentPosition.
  // If _locationAcquisitionError is null and _currentPosition is null (e.g., after tapping "Show Default Map"
  // and _requestAndSetCurrentPosition hasn't successfully run again), you might want to show this.
  // For simplicity, the above _buildErrorUI provides a path to clear error and potentially show this via rebuild.
  // For a direct fallback map without current location:
  Widget _buildFallbackMap() {
    return GoogleMap(
      initialCameraPosition: _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
    );
  }
}

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => MapPageState();
// }

// class MapPageState extends State<MapPage> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();

//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(37.42796133580664, -122.085749655962),
//     zoom: 14.4746,
//   );

//   static const CameraPosition _kLake = CameraPosition(
//     bearing: 192.8334901395799,
//     target: LatLng(37.43296265331129, -122.08832357078792),
//     tilt: 59.440717697143555,
//     zoom: 19.151926040649414,
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: GoogleMap(
//         mapType: MapType.hybrid,
//         initialCameraPosition: _kGooglePlex,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: _goToTheLake,
//         label: const Text('To the lake!'),
//         icon: const Icon(Icons.directions_boat),
//       ),
//     );
//   }

//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }
