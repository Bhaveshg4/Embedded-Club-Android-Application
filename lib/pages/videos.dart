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
          url: doc.id, // Use document ID as URL
          likes: data['likes'] ?? 0,
          dislikes: data['dislikes'] ?? 0,
        );
      }).toList();

      setState(() {});
    } catch (e) {
      print('Error fetching video data: $e');
    }
  }

  Future<void> updateLikesDislikes(int index) async {
    try {
      // Assuming you have a collection named 'videos' in Firestore
      CollectionReference<Map<String, dynamic>> videosCollection =
          FirebaseFirestore.instance.collection('videos');

      // Get the document ID for the current video
      String docId = videos[index].url;

      // Update likes and dislikes for the current video
      await videosCollection.doc(docId).update({
        'likes': videos[index].likes,
        'dislikes': videos[index].dislikes,
      });

      // Fetch the latest data for the updated video
      DocumentSnapshot<Map<String, dynamic>> updatedData =
          await videosCollection.doc(docId).get();

      // Update the local state with the latest data
      setState(() {
        videos[index] = VideoInfo(
          title: updatedData['title'],
          description: updatedData['description'],
          url: updatedData.id,
          likes: updatedData['likes'] ?? 0,
          dislikes: updatedData['dislikes'] ?? 0,
        );
      });
    } catch (e) {
      print('Error updating likes and dislikes: $e');
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
                return VideoPlayerWidget(
                  videoInfo: videos[index],
                  updateLikesDislikes: () => updateLikesDislikes(index),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final VideoInfo videoInfo;
  final VoidCallback updateLikesDislikes;

  const VideoPlayerWidget({
    Key? key,
    required this.videoInfo,
    required this.updateLikesDislikes,
  }) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.network(widget.videoInfo.url);
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: 16 / 9,
      autoPlay: false,
      looping: false,
    );

    _videoPlayerController.addListener(() {
      if (!_videoPlayerController.value.isPlaying &&
          !_videoPlayerController.value.isBuffering) {
        // Video playback ended
        _videoPlayerController.seekTo(Duration.zero);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(
            controller: _chewieController,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.videoInfo.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.videoInfo.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up),
                        onPressed: () {
                          setState(() {
                            widget.videoInfo.likes++;
                          });
                          widget.updateLikesDislikes();
                        },
                      ),
                      SizedBox(width: 4),
                      Text('${widget.videoInfo.likes} Likes'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_down),
                        onPressed: () {
                          setState(() {
                            widget.videoInfo.dislikes++;
                          });
                          widget.updateLikesDislikes();
                        },
                      ),
                      SizedBox(width: 4),
                      Text('${widget.videoInfo.dislikes} Dislikes'),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _chewieController.play();
                        },
                        child: const Text('Play Video'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}

class VideoInfo {
  final String title;
  final String description;
  final String url;
  int likes;
  int dislikes;

  VideoInfo({
    required this.title,
    required this.description,
    required this.url,
    required this.likes,
    required this.dislikes,
  });
}
