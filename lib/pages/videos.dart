import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  late List<VideoInfo> videos;
  late Future<void> _fetchVideoData;

  @override
  void initState() {
    super.initState();
    _fetchVideoData = fetchVideoData();
  }

  Future<void> fetchVideoData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('videos').get();

      videos = querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data();
        return VideoInfo(
          title: data['title'],
          description: data['description'],
          url: data['videoUrl'],
        );
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error fetching video data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 52, 95, 214),
        title: Text('Tutorial Videos'),
      ),
      body: FutureBuilder(
        future: _fetchVideoData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (videos.isEmpty) {
            return Center(child: Text('No videos available.'));
          } else {
            return ListView.builder(
              itemCount: videos.length,
              itemBuilder: (context, index) {
                return VideoCard(videoInfo: videos[index]);
              },
            );
          }
        },
      ),
    );
  }
}

class VideoCard extends StatelessWidget {
  final VideoInfo videoInfo;

  const VideoCard({
    Key? key,
    required this.videoInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Chewie(
              controller: ChewieController(
                videoPlayerController:
                    // ignore: deprecated_member_use
                    VideoPlayerController.network(videoInfo.url),
                aspectRatio: 16 / 9,
                autoPlay: false,
                looping: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  videoInfo.title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  videoInfo.description,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Play Video'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class VideoInfo {
  final String title;
  final String description;
  final String url;

  VideoInfo({
    required this.title,
    required this.description,
    required this.url,
  });
}
