import 'package:equatable/equatable.dart';

abstract class VideoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadVideo extends VideoEvent {}