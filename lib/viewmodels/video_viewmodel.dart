import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import '../blocs/video_bloc.dart';
import '../blocs/video_event.dart';
import '../blocs/video_state.dart';

class VideoViewModel {
  final VideoBloc bloc;

  VideoViewModel(this.bloc);

  void loadVideo() {
    bloc.add(LoadVideo());
  }

  Widget buildVideoPlayer(BuildContext context) {
    return BlocBuilder<VideoBloc, VideoState>(
      builder: (context, state) {
        if (state is VideoLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is VideoLoaded) {
          return Column(
            children: [
              AspectRatio(
                aspectRatio: state.controller.value.aspectRatio,
                child: VideoPlayer(state.controller),
              ),
              VideoControls(controller: state.controller),
            ],
          );
        } else if (state is VideoError) {
          return Center(child: Text(state.message));
        } else {
          return  Center(child: Text('Press the button to load video'));
        }
      },
    );
  }
}

class VideoControls extends StatelessWidget {
  final VideoPlayerController controller;

  VideoControls({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
          onPressed: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        IconButton(
          icon: Icon(Icons.stop),
          onPressed: () {
            controller.pause();
            controller.seekTo(Duration.zero);
          },
        ),
      ],
    );
  }
}