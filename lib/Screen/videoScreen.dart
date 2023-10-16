import 'package:flutter/material.dart';
import 'package:login_mobile_page/main.dart';
import 'package:video_player/video_player.dart';

import '../model/videoelement.dart';

class VideoScreen extends StatefulWidget {
  VideosElement user;
  VideoScreen({super.key, required this.user});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.user.videofile)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
     
      elevation: 6,
      child: Container(
        margin: EdgeInsets.only(left: 30, right: 30, bottom: 30, top: 2),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.user.title == "" ? "No Title" : widget.user.title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on,
                size: 25,
                color: Colors.grey,
              ),
              SizedBox(
                width: 5,
              ),
              Text(
                widget.user.location,
                style: TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 15,
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _controller.value.isInitialized
              ? InkWell(
                  onTap: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  child: Stack(
                    children: [
                      Container(
                        height: 230,
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      ),
                      Positioned(
                          top: 100,
                          left: 120,
                          child: Center(
                            child: SizedBox.square(
                                dimension: 50,
                                child: _controller.value.isPlaying
                                    ? SizedBox()
                                    : Image.asset('Images/play-button.png')),
                          ))
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          Text(
            widget.user.disc == "" ? "No description...." : widget.user.disc,
            style: TextStyle(
              fontSize: 20,
              color: Colors.black45,
            ),
            softWrap: false,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ]),
      ),
    );
    ;
  }
}
