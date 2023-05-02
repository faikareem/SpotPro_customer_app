import 'package:flutter/material.dart';
import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LatLng {
  /// Creates a geographical location specified in degrees [latitude] and
  /// [longitude].
  ///
  /// The latitude is clamped to the inclusive interval from -90.0 to +90.0.
  ///
  /// The longitude is normalized to the half-open interval from -180.0
  /// (inclusive) to +180.0 (exclusive)
  const LatLng(double latitude, double longitude)
      : latitude =
  (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
        longitude = (longitude + 180.0) % 360.0 - 180.0;

  /// The latitude in degrees between -90.0 and 90.0, both inclusive.
  final double latitude;

  /// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
  final double longitude;

  LatLng operator +(LatLng o) {
    return LatLng(latitude + o.latitude, longitude + o.longitude);
  }

  LatLng operator -(LatLng o) {
    return LatLng(latitude - o.latitude, longitude - o.longitude);
  }

  dynamic toJson() {
    return <double>[latitude, longitude];
  }

  dynamic toGeoJsonCoordinates() {
    return <double>[longitude, latitude];
  }

  static LatLng _fromJson(List<dynamic> json) {
    return LatLng(json[0], json[1]);
  }

  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  @override
  bool operator ==(Object o) {
    return o is LatLng && o.latitude == latitude && o.longitude == longitude;
  }

  @override
  int get hashCode => hashValues(latitude, longitude);
}


class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  LatLng _selectedLocation = LatLng(74, 10);
  bool _isLoading = false;

  Future<void> _updateUserLocation() async {
    setState(() {
      _isLoading = true;
    });

    final User user = FirebaseAuth.instance.currentUser!;
    final DocumentReference userRef =
    FirebaseFirestore.instance.collection('users').doc(user.uid);

    try {
      await userRef.update({
        'latlon': {'latitude': _selectedLocation.latitude, 'longitude': _selectedLocation.longitude}
      });
      Navigator.of(context).pop(); // Exit the page
    } catch (e) {
      print('Failed to update user location: $e');
      // Display an error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to update user location.'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('Select Location'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : FlutterLocationPicker(
          initZoom: 11,
          minZoomLevel: 5,
          maxZoomLevel: 16,
          trackMyPosition: true,
          searchBarBackgroundColor: Colors.white70,
          searchBarHintColor: Colors.purple.shade100,
          mapLoadingBackgroundColor: Colors.purple.shade100,
          markerIcon: Icon(Icons.location_on,
            size: 50,
            color: Colors.purpleAccent,
          ),
          selectLocationButtonText: 'Set Location',
          locationButtonBackgroundColor: Colors.purple,
          zoomButtonsBackgroundColor: Colors.purple,
          selectLocationButtonStyle: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)
            ))
          ),
          mapLanguage: 'en',
          onError: (e) => print(e),
          onPicked: (pickedData) {

            _selectedLocation = LatLng(pickedData.latLong.latitude, pickedData.latLong.longitude);
            if(_selectedLocation != null)_updateUserLocation();

          }),

    );
  }
}
