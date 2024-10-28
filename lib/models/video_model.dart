// lib/models/video_model.dart
class Video {
  final String id;
  late final String title;
  final String thumbnailUrl;
  final String duration;
  final String uploadTime;
  final String views;
  final String author;
  final String videoUrl;
  final String description;
  final String subscriber;
  final bool isLive;

  Video({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.uploadTime,
    required this.views,
    required this.author,
    required this.videoUrl,
    required this.description,
    required this.subscriber,
    required this.isLive,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? 'Untitled',
      thumbnailUrl: json['thumbnailUrl']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '0:00',
      uploadTime: json['uploadTime']?.toString() ?? 'Unknown',
      views: json['views']?.toString() ?? '0',
      author: json['author']?.toString() ?? 'Unknown',
      videoUrl: json['videoUrl']?.toString() ?? '',
      description: json['description']?.toString() ?? 'No description available',
      subscriber: json['subscriber']?.toString() ?? '0',
      isLive: json['isLive'] ?? false,  // assuming `isLive` is boolean
    );
  }
}
