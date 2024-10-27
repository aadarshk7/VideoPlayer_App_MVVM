import 'package:equatable/equatable.dart';
import 'package:video_player/video_player.dart';

abstract class VideoState extends Equatable {
  @override
  List<Object> get props => [];
}

class VideoInitial extends VideoState {}

class VideoLoading extends VideoState {}

class VideoLoaded extends VideoState {
  final VideoPlayerController controller;

  VideoLoaded(this.controller);

  @override
  List<Object> get props => [controller];
}

class VideoError extends VideoState {
  final String message;

  VideoError(this.message);

  @override
  List<Object> get props => [message];
}