import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Import flutter_map
import 'package:latlong2/latlong.dart'; // Import latlong2 for LatLng

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapExamplePageState();
}

class _MapExamplePageState extends State<MapPage> {
  // Define a custom marker icon
  final Widget customMarkerIcon = Icon(
    Icons.location_pin,
    color: Colors.red.shade700,
    size: 40.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        // Map Options
        options: MapOptions(
          initialCenter: const LatLng(
            3.1390,
            101.6869,
          ), // Example: Kuala Lumpur
          initialZoom: 13.0,
          minZoom: 2.0,
          maxZoom: 18.0,
        ),
        // Map Layers
        children: [
          // 1. Tile Layer (the base map)
          TileLayer(
            //urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            urlTemplate:
                'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
            userAgentPackageName:
                'com.ijglobaltech.miloca', // Your package name
          ),

          // // 2. Image Overlay (an image placed over a specific area)
          // // Make sure to add 'assets/your_overlay_image.png' to your pubspec.yaml under 'assets:'
          // // For example, you can use a transparent image for testing, like a logo.
          // ImageOverlay(
          //   imageProvider: const AssetImage('assets/your_overlay_image.png'), // Path to your image asset
          //   bounds: LatLngBounds(
          //     // Define the geographical bounds for the image
          //     const LatLng(3.145, 101.680), // Top-left (e.g., slightly north-west of KL center)
          //     const LatLng(3.135, 101.695), // Bottom-right (e.g., slightly south-east of KL center)
          //   ),
          //   opacity: 0.7, // Adjust opacity if needed
          // ),

          // 3. Marker Layer (for displaying individual markers)
          MarkerLayer(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: const LatLng(
                  3.1390,
                  101.6869,
                ), // Marker at Kuala Lumpur center
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tapped KL Marker!')),
                    );
                  },
                  child: customMarkerIcon, // Using our custom icon widget
                ),
              ),
              Marker(
                width: 80.0,
                height: 80.0,
                point: const LatLng(
                  3.1500,
                  101.7110,
                ), // Another marker (e.g., Petronas Towers area)
                child: const Icon(
                  Icons.business, // Another icon
                  color: Colors.pink,
                  size: 35.0,
                ),
              ),
            ],
          ),

          // Optional: Add other layers like Polylines, Polygons, etc.
        ],
      ),
    );
  }
}
