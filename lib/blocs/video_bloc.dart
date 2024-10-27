import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';
import 'video_event.dart';
import 'video_state.dart';
import '../repository/video_repository.dart';

class VideoBloc extends Bloc<VideoEvent, VideoState> {
  final VideoRepository repository;

  VideoBloc(this.repository) : super(VideoInitial()) {
    on<LoadVideo>(_onLoadVideo);
  }

  Future<void> _onLoadVideo(LoadVideo event, Emitter<VideoState> emit) async {
    emit(VideoLoading());
    try {
      final videos = await repository.fetchVideos();
      if (videos.isNotEmpty) {
        final controller = VideoPlayerController.network(videos[0].videoUrl);
        await controller.initialize();
        emit(VideoLoaded(controller));
      } else {
        emit(VideoError('No videos found'));
      }
    } catch (e) {
      emit(VideoError(e.toString()));
    }
  }
}
