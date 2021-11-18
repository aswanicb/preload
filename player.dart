import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preload/controller.dart';
import 'package:video_player/video_player.dart';

class Player extends StatefulWidget {
  final String s;
  final int i;
  const Player({
    Key? key,
    required this.s,
    required this.i,
  }) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  bool autoplay = true;

  Future initializePlayer() async {
    _videoPlayerController = VideoPlayerController.network(widget.s);
    await Future.wait([_videoPlayerController.initialize()]);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: autoplay,
      showControls: false,
      looping: true,
    );
    setState(() {});
  }

  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  Future<String> getFuture() async {
    await Future.delayed(const Duration(seconds: 1));
    return widget.s;
  }

  final PCC c = Get.find();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getFuture(),
      builder: (cx, s) {
        if (s.hasData) {
          return GetBuilder<PCC>(builder: (_) {
            if (widget.i == c.api) {
              //Set AutoPlay True Here
              //If Index equals Auto Play Index
              // _chewieController = ChewieController(
              //   videoPlayerController: _videoPlayerController,
              //   autoPlay: true,
              //   showControls: false,
              //   looping: true,
              // );

              //I need to set autoplay false when then user taps on the comment button.

              autoplay = true;
              print('AutoPlaying ${c.api}');
            } else {
              autoplay = false;
              //Set AutoPlay False
              print('AutoPlay Stopped for ${widget.i}');
            }
            //Player Here
            return Stack(
              children: [
                _chewieController != null &&
                        _chewieController
                            .videoPlayerController.value.isInitialized
                    ? Stack(
                        children: [
                          Chewie(
                            controller: _chewieController,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (_chewieController
                                  .videoPlayerController.value.isPlaying) {
                                print("playing");
                                setState(() {
                                  autoplay = false;
                                  _chewieController.videoPlayerController
                                      .pause();
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 40),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: const [
                                        Text(
                                          'Comments',
                                          style: TextStyle(
                                            fontSize: 22,
                                            color: Colors.amber,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Icon(
                                          Icons.comment,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )
                    : const CircularProgressIndicator(
                        color: Colors.lightBlueAccent,
                      ),
              ],
            );
          });
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
