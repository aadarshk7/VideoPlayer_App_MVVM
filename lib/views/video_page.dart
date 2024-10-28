// void _playNextVideo() {
//   if (_currentVideoIndex < widget.videoUrls.length - 1) {
//     _currentVideoIndex++;
//     _downloadAndPlayVideo(_currentVideoIndex);
//   } else {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('No next video available')),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import '../repository/video_repository.dart';

class VideoPage extends StatefulWidget {
  final List<String> videoUrls;
  final List<String> fileNames;

  VideoPage({required this.videoUrls, required this.fileNames});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? _controller;
  Timer? _timer;
  final VideoRepository _videoRepository = VideoRepository();
  int _currentVideoIndex = 0;
  double _playbackSpeed = 1.0;

  @override
  void initState() {
    super.initState();
    _downloadAndPlayVideo(_currentVideoIndex);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft
    ]);
  }

  Future<void> _downloadAndPlayVideo(int index) async {
    try {
      final filePath = await _videoRepository.downloadVideo(
          widget.videoUrls[index], widget.fileNames[index]);
      _initializeAndPlay(filePath, index);
    } catch (e) {
      print('Error downloading video: $e');
    }
  }

  Future<void> _initializeAndPlay(String path, int index) async {
    _controller?.dispose();
    _controller = VideoPlayerController.file(File(path));
    await _controller!.initialize();

    _controller!.addListener(() {
      setState(() {});
    });

    setState(() {});
    _controller?.setPlaybackSpeed(_playbackSpeed);
    _controller?.play();

    _managePlaybackSequence(index);
  }

  void _managePlaybackSequence(int index) {
    switch (index) {
      case 0:
        _timer = Timer(Duration(seconds: 15), () {
          _controller?.pause();
          _currentVideoIndex++;
          _downloadAndPlayVideo(_currentVideoIndex);
        });
        break;
      case 1:
        _timer = Timer(Duration(seconds: 20), () {
          _controller?.pause();
          _currentVideoIndex++;
          _downloadAndPlayVideo(_currentVideoIndex);
        });
        break;
      case 2:
        _timer = Timer(_controller!.value.duration, () {
          _currentVideoIndex = 1;
          _downloadAndPlayVideo(_currentVideoIndex);
        });
        break;
    }
  }

  void _playNextVideo() {
    if (_currentVideoIndex < widget.videoUrls.length - 1) {
      _currentVideoIndex++;
      _downloadAndPlayVideo(_currentVideoIndex);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No next video available')),
      );
    }
  }

  void _playPreviousVideo() {
    if (_currentVideoIndex > 0) {
      _currentVideoIndex--;
      _downloadAndPlayVideo(_currentVideoIndex);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No previous video available')),
      );
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(() {});
    _controller?.dispose();
    _timer?.cancel();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   title: Text(
      //     widget.fileNames[_currentVideoIndex],
      //     style: TextStyle(
      //       fontWeight: FontWeight.bold,
      //       fontSize: 20,
      //       color: Colors.white, // Ensure high contrast
      //       shadows: [
      //         Shadow(
      //           blurRadius: 4.0,
      //           color:
      //               Colors.black.withOpacity(0.10), // Soft shadow for clarity
      //           offset: Offset(2.0, 2.0),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme:
            IconThemeData(color: Colors.white), // Set back arrow to white
        title: Text(
          widget.fileNames[_currentVideoIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white, // Ensure title text is white for visibility
            shadows: [
              Shadow(
                blurRadius: 4.0,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(2.0, 2.0),
              ),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          Center(
            child: _controller != null && _controller!.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
          Positioned(
            bottom: 110,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black87.withOpacity(0.7),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_controller != null && _controller!.value.isInitialized)
                    VideoProgressIndicator(
                      _controller!,
                      allowScrubbing: true,
                      colors: const VideoProgressColors(
                        playedColor: Colors.blueAccent,
                        backgroundColor: Colors.grey,
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _controller != null &&
                                  _controller!.value.isInitialized
                              ? _formatDuration(_controller!.value.position)
                              : '00:00',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          _controller != null &&
                                  _controller!.value.isInitialized
                              ? _formatDuration(_controller!.value.duration)
                              : '00:00',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous, color: Colors.white),
                        onPressed: _playPreviousVideo,
                      ),
                      IconButton(
                        icon: Icon(
                          _controller != null && _controller!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_controller != null) {
                              _controller!.value.isPlaying
                                  ? _controller!.pause()
                                  : _controller!.play();
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next, color: Colors.white),
                        onPressed: _playNextVideo,
                      ),
                      DropdownButton<double>(
                        value: _playbackSpeed,
                        items: const [
                          DropdownMenuItem(value: 0.5, child: Text("0.5x")),
                          DropdownMenuItem(value: 1.0, child: Text("1.0x")),
                          DropdownMenuItem(value: 1.5, child: Text("1.5x")),
                          DropdownMenuItem(value: 2.0, child: Text("2.0x")),
                        ],
                        onChanged: (value) {
                          if (value != null && _controller != null) {
                            setState(() {
                              _playbackSpeed = value;
                              _controller!.setPlaybackSpeed(_playbackSpeed);
                            });
                          }
                        },
                        dropdownColor: Colors.black,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.white,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.black,
    );
  }
}
