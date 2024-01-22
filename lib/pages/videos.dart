import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  int likes = 0;
  int dislikes = 0;

  @override
  void initState() {
    super.initState();

    initializeVideoPlayer();
  }

  Future<void> initializeVideoPlayer() async {
    try {
      _videoPlayerController = VideoPlayerController.network(
          'https://drive.google.com/uc?export=view&id=1rI8qzTkl2nP_kojJblGJzJandHkuCdko');
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        aspectRatio: 16 / 9,
        autoPlay: false,
        looping: false,
      );
      setState(() {});
    } catch (e) {
      print('Error initializing video player: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tutorial Videos'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: _videoPlayerController.value.isInitialized
                ? Chewie(
                    controller: _chewieController,
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Video Title',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Video Description: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce fermentum auctor nulla, vel suscipit dui volutpat at. Integer vel consequat libero.',
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
                              likes++;
                            });
                          },
                        ),
                        SizedBox(width: 4),
                        Text('$likes Likes'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {
                            setState(() {
                              dislikes++;
                            });
                          },
                        ),
                        SizedBox(width: 4),
                        Text('$dislikes Dislikes'),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.save_alt),
                          onPressed: () {},
                        ),
                        SizedBox(width: 4),
                        Text('Save'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    _chewieController.play();
                  },
                  child: Text('Play Video'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
