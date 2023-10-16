import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:login_mobile_page/model/videoelement.dart';
import 'package:video_player/video_player.dart';

import '../location/gps.dart';
import '../main.dart';

class AddVideo extends StatefulWidget {
  const AddVideo({super.key});

  @override
  State<AddVideo> createState() => _AddVideoState();

  static videoshow() {}
}

class _AddVideoState extends State<AddVideo> {
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  File? video;
  VideoPlayerController? _videoPlayerController;

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
      address = placemarks[0].subLocality!+" "+placemarks[0].locality!+", "+ placemarks[0].country!;
    });
    for (int i = 0; i < placemarks.length; i++) {

      log("INDEX $i ${placemarks[i]}");
    }
  }

  @override
  void initState() {
    super.initState();
     _gps.startPositionStream(_handlePositionStream);
    
  }

  Future<void> pickvideoingallery() async {
    final videopicked =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (videopicked != null) {
      video = File(videopicked.path);
      _videoPlayerController = VideoPlayerController.file(video!)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController!.play();
          _videoPlayerController!.setLooping(true);
        });
    }
  }

  Future<void> pickvideofromcamera() async {
    final videopicked = await ImagePicker().pickVideo(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxDuration: Duration(seconds: 60));
    if (videopicked != null) {
      video = File(videopicked.path);
      _videoPlayerController = VideoPlayerController.file(video!)
        ..initialize().then((_) {
          setState(() {});
          _videoPlayerController!.play();
          _videoPlayerController!.setLooping(true);
        });
    }
  }

  @override
  void dispose() {
    _videoPlayerController!.dispose();
    _title.dispose();
    _description.dispose();

    super.dispose();
    _gps.stopPositionStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Upload Video'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          VideosElement listadd =
              VideosElement(_description.text, _title.text, video!, address);
          videoElement.add(listadd);
          setState(() {});
          _title.clear();
          _description.clear();
          video = null;
        },
        child: Image.asset(
          'Images/cloud-computing.png',
          fit: BoxFit.cover,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 2),
        child: SingleChildScrollView(
          child: Column(children: [
            Center(
                child: Container(
              height: 80,
              width: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                      image: AssetImage('Images/Animation1.gif'),
                      fit: BoxFit.cover)),
            )),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _title,
              maxLines: 1,
              decoration: InputDecoration(
                hintText: 'Add title in video....',
                labelText: 'Title',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 28, 167, 98), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 28, 167, 98), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _description,
              maxLines: null,
              decoration: InputDecoration(
                hintText: ' Add Description',
                labelText: 'description',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 28, 167, 98), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 28, 167, 98), width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    
                  },
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
                  width: 5,
                ),
                address == ""
                    ? Text(
                        'Choose Your Location...',
                        style: TextStyle(fontSize: 15, color: Colors.grey),
                      )
                    : Text(
                        address,
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    _videopicker();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                            image: AssetImage('Images/video-camera.png'),
                            fit: BoxFit.cover)),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Choose Video in gallery or camera...',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            video == null
                ? Container(
                    height: 230,
                    width: double.infinity,
                    child: Center(
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          // border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(20),
                            image: DecorationImage(
                                image:
                                    AssetImage("Images/video-processing.png"),
                                fit: BoxFit.cover)),
                      ),
                    ),
                  )
                : videoshow(),
          ]),
        ),
      ),
    );
  }

  void _videopicker() {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        )),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 10, bottom: 30),
            children: [
              Text(
                'Pick Video ',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        pickvideoingallery();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(120, 120)),
                      child: Image.asset('Images/gallery.png')),
                  ElevatedButton(
                      onPressed: () {
                        pickvideofromcamera();
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: CircleBorder(),
                          fixedSize: Size(120, 120)),
                      child: Image.asset('Images/photograph.png')),
                ],
              )
            ],
          );
        });
  }

  Widget videoshow() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 400, maxWidth: 400),
      child: GestureDetector(
        onTap: () {
          setState(() {});
          _videoPlayerController!.value.isPlaying
              ? _videoPlayerController!.pause()
              : _videoPlayerController!.play();
        },
        child: AspectRatio(
          aspectRatio: _videoPlayerController!.value.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(_videoPlayerController!),
              Center(
                child: _videoPlayerController!.value.isPlaying
                    ? SizedBox()
                    : SizedBox.square(
                        dimension: 50,
                        child: Image.asset('Images/play-button.png')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
