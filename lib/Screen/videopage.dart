import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_mobile_page/Screen/addvideo.dart';
import 'package:login_mobile_page/Screen/videoScreen.dart';
import 'package:login_mobile_page/model/videoelement.dart';
import 'package:video_player/video_player.dart';

import '../main.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  List<VideosElement> searchvideo = [];
  bool _issearch = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        centerTitle: true,
        title: _issearch
            ? TextField(
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Title....'),
                autofocus: true,
                style: TextStyle(fontSize: 17, letterSpacing: 0.5),
                onChanged: (val) {
                  searchvideo.clear();
                  for (var i in videoElement) {
                    if (i.title.toLowerCase().contains(val.toLowerCase())) {
                      searchvideo.add(i);
                    }
                    setState(() {
                      searchvideo;
                    });
                  }
                },
              )
            : Text('Video'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _issearch = !_issearch;
                });
              },
              icon: Icon(_issearch
                  ? CupertinoIcons.clear_circled_solid
                  : Icons.search))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddVideo()));
        },
        child: Image.asset("Images/button.png"),
      ),
      body: InkWell(
        onTap: () {
          setState(() {});
        },
        child: Container(
            child: videoElement.isNotEmpty
                ? ListView.builder(
                    itemCount:_issearch?searchvideo.length: videoElement.length,
                    itemBuilder: (context, index) {
                      // final reverse = videoElement.reversed.toList();
                      return VideoScreen(user: _issearch?searchvideo[index]: videoElement[index]);
                    })
                : Container(
                    margin: EdgeInsets.all(20),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Video is not present!😯',
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontStyle: FontStyle.italic),
                        ),
                        Text(
                            "If you want to add a new video, click on the add(+) button.😊.",
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 15,
                                fontStyle: FontStyle.italic)),
                      ],
                    )),
                  )),
      ),
    );
  }
}
