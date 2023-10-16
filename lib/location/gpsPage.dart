
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login_mobile_page/location/gps.dart';



class GpsPages extends StatefulWidget {
  const GpsPages({super.key});

  @override
  State<GpsPages> createState() => _GpsPagesState();
}

class _GpsPagesState extends State<GpsPages> {
  final GPS _gps = GPS();
  Position? _userPostion;
  Exception? _exception;
  double? lat;
  double? longs;
  String address = "";
  void _handlePositionStream(Position position) {
    setState(() {
      _userPostion = position;
      lat = position.latitude;
      longs = position.longitude;
    });
    getAddress(position.latitude, position.longitude);
  }

  getAddress(lat, longs) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, longs);
    setState(() {
      address = placemarks[0].street! + " " + placemarks[0].country!;
    });
    for (int i = 0; i < placemarks.length; i++) {
      print("INDEX $i ${placemarks[i]}");
    }
  }

  @override
  void initState() {
    super.initState();
    _gps.startPositionStream(_handlePositionStream);
  }

  @override
  void dispose() {
    super.dispose();
    _gps.stopPositionStream();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (_exception != null) {
      child = Text("Please provide GPS permissions", style: TextStyle(fontSize: 15, color: Colors.grey));
    } else if (_userPostion == null) {
      child = CircularProgressIndicator();
    } else {
      child = Text("address: $address", style: TextStyle(fontSize: 15, color: Colors.grey));
    }
    return Scaffold(
      body: Row(
        children: [
          InkWell(
            onTap: () {},
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                      image: AssetImage('Images/placeholder.png'),
                      fit: BoxFit.cover)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          child
        ],
      ),
    );
  }
}
