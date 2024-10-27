// lib/views/video_page.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'dart:io';
import '../repository/video_repository.dart';

class VideoPage extends StatefulWidget {
  // final String videoUrl;
  final List<String> videoUrls;
  final List<String> fileNames;
  // final String fileName;

  VideoPage({required this.videoUrls, required this.fileNames});

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  VideoPlayerController? _controller;
  Timer? _timer;
  final VideoRepository _videoRepository = VideoRepository();
  int _currentVideoIndex = 0;

  @override
  void initState() {
    super.initState();
    _downloadAndPlayVideo(_currentVideoIndex);
  }

  Future<void> _downloadAndPlayVideo(int index) async {
    try {
      final filePath = await _videoRepository.downloadVideo(
          widget.videoUrls[index], widget.fileNames[index]);
      _initializeAndPlay(filePath, index);
    } catch (e) {
      //if any occur while downloading the video
      print('Error downloading video: $e');
    }
  }

  Future<void> _initializeAndPlay(String path, int index) async {
    _controller?.dispose();
    _controller = VideoPlayerController.file(File(path));
    await _controller!.initialize();
    setState(() {});
    _controller!.play();
    _schedulePause(index);
  }

  void _schedulePause(int index) {
    _timer?.cancel();
    int pauseDuration;
    switch (index) {
      case 0:
        pauseDuration = 15;
        break;
      case 1:
        pauseDuration = 20;
        break;
      case 2:
        pauseDuration = _controller!.value.duration.inSeconds;
        break;
      default:
        pauseDuration = 0;
    }
    _timer = Timer(Duration(seconds: pauseDuration), () {
      _controller!.pause();
      if (index < 2) {
        _currentVideoIndex++;
        _downloadAndPlayVideo(_currentVideoIndex);
      } else if (index == 2) {
        _currentVideoIndex = 1;
        _controller!.play();
        _schedulePause(_currentVideoIndex);
      } else if (index == 1) {
        _currentVideoIndex = 0;
        _controller!.play();
        _schedulePause(_currentVideoIndex);
      }
    });
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

  @override
  void dispose() {
    _controller?.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Player'),
      ),
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller!.value.aspectRatio,
                    child: VideoPlayer(_controller!),
                  ),
                  VideoProgressIndicator(_controller!, allowScrubbing: true),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous),
                        onPressed: () {
                          // logic to play previous video
                        },
                      ),
                      IconButton(
                        icon: Icon(_controller!.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow),
                        onPressed: () {
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next),
                        onPressed: _playNextVideo,
                      ),
                    ],
                  ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
