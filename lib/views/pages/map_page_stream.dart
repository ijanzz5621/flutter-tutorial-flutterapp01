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
  static const double _defaultZoomLevel = 18.0;
  StreamSubscription<Position>? _positionStreamSubscription;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(4.2105, 101.9758),
    zoom: _defaultZoomLevel,
  );

  Marker? _userLocationMarker;
  BitmapDescriptor? _personIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomIcon();
    _startLocationUpdates();
  }

  Future<void> _loadCustomIcon() async {
    _personIcon = await BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/images/person-marker-icon.png',
    );
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _showSnackbar(String message, {bool isError = false}) {
    if (mounted) {
      ScaffoldMessenger.of(context).removeCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? Theme.of(context).colorScheme.error : null,
          behavior: SnackBarBehavior.floating,
        ),
      );
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

  Future<void> _startLocationUpdates() async {
    setState(() {
      _isLoadingLocation = true;
      _locationAcquisitionError = null;
    });

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
              debugPrint(
                'Location Update: ${position.latitude}, ${position.longitude}',
              );
              setState(() {
                _currentPosition = LatLng(
                  position.latitude,
                  position.longitude,
                );
                _isLoadingLocation = false;

                _userLocationMarker = Marker(
                  markerId: const MarkerId('user_location'),
                  position: _currentPosition!,
                  icon: _personIcon ?? BitmapDescriptor.defaultMarker,
                  anchor: const Offset(0.5, 0.5),
                );
              });

              if (_controller.isCompleted) {
                final GoogleMapController mapController =
                    await _controller.future;
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(
                      target: _currentPosition!,
                      zoom: _defaultZoomLevel,
                    ),
                  ),
                );
              }
            },
            onError: (e) {
              String errorMessage = e.toString();
              if (e is LocationServiceDisabledException) {
                errorMessage = 'Location services disabled.';
              } else if (e is PermissionDeniedException) {
                errorMessage = 'Location permissions denied.';
              }
              debugPrint("Error in location stream: $errorMessage");
              setState(() {
                _locationAcquisitionError = errorMessage;
                _isLoadingLocation = false;
                _currentPosition = null;
              });
              _showSnackbar(_locationAcquisitionError!, isError: true);
            },
            onDone: () {
              debugPrint("Location stream ended.");
              _showSnackbar("Location tracking stopped.", isError: false);
              _positionStreamSubscription = null;
            },
            cancelOnError: true,
          );
    } catch (e) {
      String errorMessage = e.toString().replaceFirst("Exception: ", "");
      debugPrint("Initial location setup error: $errorMessage");
      setState(() {
        _locationAcquisitionError = errorMessage;
        _isLoadingLocation = false;
        _currentPosition = null;
      });
      _showSnackbar(_locationAcquisitionError!, isError: true);
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

    if (_locationAcquisitionError != null) {
      return _buildErrorUI(_locationAcquisitionError!);
    }

    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: _currentPosition != null
          ? CameraPosition(target: _currentPosition!, zoom: _defaultZoomLevel)
          : _kGooglePlex,
      onMapCreated: (GoogleMapController controller) {
        if (!_controller.isCompleted) {
          _controller.complete(controller);
        }
      },
      myLocationEnabled: false, // Disable default blue dot
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      liteModeEnabled: false,
      mapToolbarEnabled: true,
      buildingsEnabled: true,
      trafficEnabled: true,
      indoorViewEnabled: false,
      markers: _userLocationMarker != null ? {_userLocationMarker!} : {},
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
              onPressed: () {
                _positionStreamSubscription?.cancel();
                _startLocationUpdates();
              },
              label: const Text('Retry'),
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _locationAcquisitionError = null;
                  _isLoadingLocation = false;
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
