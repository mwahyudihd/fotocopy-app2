import 'package:fotocopy_app/pages/absensi/tabel_absen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationTracking extends StatefulWidget {
  final String? setNama;
  LocationTracking({super.key, this.setNama});

  @override
  State<LocationTracking> createState() => _LocationTrackingState();
}

class _LocationTrackingState extends State<LocationTracking> {
  String? _currentAddress;
  Position? _currentPosition;
  String _userId = '';

  Future<void> _loadUserSesi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userId = prefs.getString('userId') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserSesi();
  }

  Future _simpan() async {
    final response = await http.post(
        Uri.parse('https://hafiz.barudakkoding.com/fotocopy-api/public/absen'),
        body: {
          "uid": _userId,
          "nama": widget.setNama,
          "lokasi": _currentAddress,
          "kordinat":
              "${_currentPosition?.latitude}, ${_currentPosition?.longitude}"
        });
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.amberAccent,
        ),
        centerTitle: true,
        backgroundColor: Colors.brown,
        title: const Text("Absensi", style: TextStyle(color: Colors.amberAccent),),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Card(
              child: Text('Silahkan set lokasi anda!'),
            ),
            SizedBox(
              height: 10.0,
            ),
            if (_currentPosition != null)
              Card(
                child: Text(
                    "Your Position is:  LAT: ${_currentPosition?.latitude}, LNG: ${_currentPosition?.longitude}"),
              ),
            if (_currentAddress != null)
              Card(
                child: Text('${_currentAddress}'),
              ),
            if (_currentAddress != null)
              ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.brown),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    'Yakin posisi ada sudah benar untuk absensi?!'),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      onPressed: () {
                                        Navigator.pop(
                                            context); // Close the dialog
                                      },
                                      child: Text('Batal',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blueAccent),
                                      onPressed: () {
                                        _simpan();
                                        final snackBar = SnackBar(
                                          content: Text(
                                              'Absensi berhasil disubmit, silahkan reload halaman ini!'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    TabelAbsen()),
                                            (route) => false);
                                      },
                                      child: Text('Ya',
                                          style:
                                              TextStyle(color: Colors.white)),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.amberAccent),
                  ))
            else
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent),
                child: const Text(
                  "Get location",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  _getCurrentPosition();
                },
              ),
          ],
        ),
      ),
    );
  }

  Future _submit() async {
    final response = await http.post(
        Uri.parse('https://hafiz.barudakkoding.com/fotocopy-api/public/absen'),
        body: {
          "uid": "",
          "nama": "",
          "lokasi": _currentAddress,
          "kordinat":
              '${_currentPosition?.latitude},${_currentPosition?.longitude}}',
        });
    if (response.statusCode == 200) {
      final snackBar = SnackBar(
        content: Text('Absensi berhasil disubmit!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return true;
    }
    return false;
  }
}
