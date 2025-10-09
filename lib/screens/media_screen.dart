import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Fixed: Complete import

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isVideoInitialized = false;
  bool _isAudioReady = false;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
    _initializeAudio();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() => _isPlaying = state == PlayerState.playing);
    });
  }

  Future<void> _initializeVideo() async {
    try {
      _videoController =
          VideoPlayerController.asset('assets/videos/sample.mp4');
      await _videoController!.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoController!,
        autoPlay: false,
        looping: true,
        showControls: true, // Enables play/pause/stop
      );
      setState(() => _isVideoInitialized = true);
    } catch (e) {
      print('Video init error: $e'); // For debugging
    }
  }

  Future<void> _initializeAudio() async {
    try {
      // Use setSourceAsset for better web compatibility
      await _audioPlayer.setSourceAsset('audio/sample.mp3');
      setState(() => _isAudioReady = true);
    } catch (e) {
      print('Audio init error: $e');
      // Still show controls; allow play() to set the source on demand
      setState(() => _isAudioReady = false);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media Player (Video + Audio)')),
      body: SingleChildScrollView(
        // Scrollable for better UX
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Video Player
            const Text('Video Player',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            if (_isVideoInitialized && _chewieController != null)
              SizedBox(
                height: 200,
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: Chewie(controller: _chewieController!),
                ),
              )
            else
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
            const SizedBox(height: 20),
            // Audio Player
            const Text('Audio Player',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 12,
              children: [
                FaIcon(
                  _isPlaying ? FontAwesomeIcons.pause : FontAwesomeIcons.play,
                  size: 28,
                  color: Colors.teal,
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: !_isAudioReady && !_isPlaying
                        ? () async {
                            // Try to load and play if not ready
                            await _audioPlayer.play(
                              AssetSource('audio/sample.mp3'),
                            );
                          }
                        : () async {
                            if (_isPlaying) {
                              await _audioPlayer.pause();
                            } else {
                              await _audioPlayer.resume();
                            }
                          },
                    child: Text(_isPlaying ? 'Pause' : 'Play'),
                  ),
                ),
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _audioPlayer.stop();
                      setState(() => _isPlaying = false);
                    },
                    child: const Text('Stop'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
