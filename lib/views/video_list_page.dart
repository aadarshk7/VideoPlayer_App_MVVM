import 'package:flutter/material.dart';
import '../repository/video_repository.dart';
import 'video_page.dart';
import '../models/video_model.dart';

class VideoListPage extends StatefulWidget {
  @override
  _VideoListPageState createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  List<Video> videoData = [];
  final VideoRepository _videoRepository = VideoRepository();

  @override
  void initState() {
    super.initState();
    _fetchVideoData();
  }

  Future<void> _fetchVideoData() async {
    try {
      final videos = await _videoRepository.fetchVideos();
      setState(() {
        videoData = videos;
      });
    } catch (e) {
      print('Error fetching video data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List of Videos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: videoData.isEmpty
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: videoData.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: ListTile(
                      leading: const Icon(Icons.video_library,
                          size: 50, color: Colors.blue),
                      title: Text(
                        videoData[index].title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Tap to play this video'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoPage(
                              videoUrls: videoData
                                  .map((video) => video.videoUrl)
                                  .toList(),
                              fileNames: List.generate(videoData.length,
                                  (index) => 'video${index + 1}.mp4'),
                            ),
                          ),
                        );
                      },
                      onLongPress: () {
                        _showEditDialog(context, index);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, int index) {
    final TextEditingController _controller =
        TextEditingController(text: videoData[index].title);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Video'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(labelText: 'Video Name'),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  videoData[index].title = _controller.text;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
