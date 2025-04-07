
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../models/video_model.dart';

class VideoRepository {
  final Dio _dio = Dio();
  int successfulDownloads = 0;
  int failedDownloads = 0;

  Future<String> downloadVideo(String videoUrl, String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      if (!fileName.endsWith('.mp4')) {
        fileName = '$fileName.mp4';
      }
      final filePath = '${dir.path}/$fileName';

      // Check if the file already exists
      if (await File(filePath).exists()) {
        print('File already exists: $filePath');
        return filePath;
      }
      await _dio.download(videoUrl, filePath,
          onReceiveProgress: (received, total) {
        if (total != -1) {
          print(
              'Download progress: ${(received / total * 100).toStringAsFixed(0)}%');
        }
      });
      successfulDownloads++;
      print('Successful downloads: $successfulDownloads');
      return filePath;
    } catch (e) {
      failedDownloads++;
      print('Failed downloads: $failedDownloads');
      throw Exception('Failed to download video: $e');
    }
  }

  Future<List<Video>> fetchVideos() async {
    try {
      final response = await _dio.get(
          'https://gist.githubusercontent.com/poudyalanil/ca84582cbeb4fc123a13290a586da925/raw/14a27bd0bcd0cd323b35ad79cf3b493dddf6216b/videos.json');
      if (response.data == null) {
        throw Exception('Response data is null');
      }
      List<dynamic> data =
          response.data is String ? jsonDecode(response.data) : response.data;
      return data.map((json) => Video.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch videos: $e');
    }
  }
}
