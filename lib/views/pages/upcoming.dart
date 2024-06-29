import 'package:ai_app/const/typography.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:url_launcher/url_launcher.dart';

class UpcomingFeaturePage extends StatefulWidget {
  @override
  _UpcomingFeaturePageState createState() => _UpcomingFeaturePageState();
}

class _UpcomingFeaturePageState extends State<UpcomingFeaturePage> {
  final List<VideoModel> videos = [
    VideoModel(
      url: 'https://cdn.openai.com/tmp/s/title_0.mp4',
      information:
          'Prompt: A stylish woman walks down a Tokyo street filled with warm glowing neon and animated city signage. She wears a black leather jacket, a long red dress, and black boots, and carries a black purse. She wears sunglasses and red lipstick. She walks confidently and casually. The street is damp and reflective, creating a mirror effect of the colorful lights. Many pedestrians walk about.',
      title: 'Creating video from text',
      paragraph:
          "We explore large-scale training of generative models on video data. Specifically, we train text-conditional diffusion models jointly on videos and images of variable durations, resolutions and aspect ratios. We leverage a transformer architecture that operates on spacetime patches of video and image latent codes. Our largest model, Sora, is capable of generating a minute of high fidelity video. Our results suggest that scaling video generation models is a promising path towards building general purpose simulators of the physical world.",
      customUrl: 'https://openai.com/index/sora/',
    ),
    VideoModel(
      url: 'https://cdn.openai.com/tmp/s/prompting_7.mp4',
      information:
          'In an ornate, historical hall, a massive tidal wave peaks and begins to crash. Two surfers, seizing the moment, skillfully navigate the face of the wave.',
      title: 'Video generation models as world simulators',
      paragraph:
          "We explore large-scale training of generative models on video data. Specifically, we train text-conditional diffusion models jointly on videos and images of variable durations, resolutions and aspect ratios. We leverage a transformer architecture that operates on spacetime patches of video and image latent codes. Our largest model, Sora, is capable of generating a minute of high fidelity video. Our results suggest that scaling video generation models is a promising path towards building general purpose simulators of the physical world.",
      customUrl: 'https://openai.com/index/sora/',
    ),
    VideoModel(
      url:
          'https://static.clipdrop.co/web/apis/super-resolution/super-resolution-demo.mp4',
      information: 'Source:clipdrop',
      title: 'Image upscaling',
      paragraph:
          "Sometimes the only thing preventing you from displaying a memorable picture is its low resolution. With the image upscaling API, transform your low resolution image into an ultra sharp high resolution image. Leaning on advanced computer vision algorithms you can upscale your up to x16.",
      customUrl: 'https://clipdrop.co/apis/docs/image-upscaling',
    ),
    VideoModel(
      url:
          'https://static.clipdrop.co/web/apis/reimagine/reimagine-1280-720.mp4',
      information: 'Source:clipdrop',
      title: 'Reimagine',
      paragraph:
          "Reimagine and view your images differently with the Reimagine API. Based on your input image, we leverage the latest Stable Diffusion tech to create an infinite number of variations to suit all your use cases!",
      customUrl: 'https://clipdrop.co/apis/docs/reimagine',
    ),
    VideoModel(
      url:
          'https://static.clipdrop.co/web/apis/sketch-to-image/sketch-to-image-1280-720.mp4',
      information: 'Source:clipdrop',
      title: 'Sketch to image',
      paragraph:
          "From a simplistic sketch and a prompt describing the content you want, generate the image of your dreams! Get more from Stable Diffusion by guiding the generation with the sketch of your choice.",
      customUrl: 'https://clipdrop.co/apis/docs/reimagine',
    ),
    // Add more videos as needed
  ];

  late List<VideoPlayerController> _controllers;
  late List<Future<void>> _initializeVideoPlayerFutures;
  late List<bool> _isTextExpandedList;

  @override
  void initState() {
    super.initState();
    _controllers = videos
        .map((video) => VideoPlayerController.network(video.url))
        .toList();
    _initializeVideoPlayerFutures =
        _controllers.map((controller) => controller.initialize()).toList();
    _isTextExpandedList = List.generate(videos.length, (_) => false);
    for (var controller in _controllers) {
      controller.setLooping(true);
    }
  }

  void _handleURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  String _trimmedText(String text) {
    const int maxLength = 100;
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength) + '...';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: Text(
          'Upcoming Feature',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(videos.length, (index) {
                final video = videos[index];
                final controller = _controllers[index];
                final initializeFuture = _initializeVideoPlayerFutures[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10.0,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                FutureBuilder(
                                  future: initializeFuture,
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      return AspectRatio(
                                        aspectRatio:
                                            controller.value.aspectRatio,
                                        child: VideoPlayer(controller),
                                      );
                                    } else {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: FloatingActionButton(
                                    mini: true,
                                    backgroundColor: const Color.fromARGB(
                                        137, 211, 205, 205),
                                    onPressed: () {
                                      setState(() {
                                        if (controller.value.isPlaying) {
                                          controller.pause();
                                        } else {
                                          controller.play();
                                        }
                                      });
                                    },
                                    child: Icon(
                                      controller.value.isPlaying
                                          ? Icons.pause
                                          : Icons.play_arrow,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isTextExpandedList[index] =
                                !_isTextExpandedList[index];
                          });
                        },
                        child: Text(
                          _isTextExpandedList[index]
                              ? video.information
                              : _trimmedText(
                                  video.information,
                                ),
                          style: TextStyle(
                            fontSize: 10,
                            fontFamily: regular,
                            color: Color.fromARGB(220, 255, 255, 255),
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          _handleURL(video.customUrl);
                        },
                        child: Text(
                          video.title,
                          style: TextStyle(
                            fontSize: 26,
                            fontFamily: regular,
                            color: Color.fromARGB(255, 255, 255, 255),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(
                        color: Color.fromARGB(255, 234, 234, 234),
                        thickness: 1.5,
                      ),
                      Text(
                        video.paragraph,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: regular,
                          color: Color.fromARGB(208, 255, 255, 255),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                );
              }),
              Center(
                child: Text(
                  "Many more coming",
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: semibold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class VideoModel {
  final String url;
  final String information;
  final String title;
  final String paragraph;
  final String customUrl;

  VideoModel({
    required this.url,
    required this.information,
    required this.title,
    required this.paragraph,
    required this.customUrl,
  });
}
