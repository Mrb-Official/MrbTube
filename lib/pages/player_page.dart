import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:wakelock_plus/wakelock_plus.dart'; // 👈 NAYA WAKELOCK IMPORT

class PlayerPage extends StatefulWidget {
  const PlayerPage({super.key});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  VideoPlayerController? _videoController;
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  bool _isPlaying = false;
  bool _showControls = true;
  String _statusText = "Tap folder icon to select video";

  @override
  void initState() {
    super.initState();
    
    // 👇 SCREEN KO ON RAKHNE WALA JADOO 👇
    WakelockPlus.enable();

    // Audio Focus Fix (Dono ko saath bajne dega)
    final AudioContext audioContext = AudioContext(
      android: AudioContextAndroid(
        isSpeakerphoneOn: true,
        stayAwake: true,
        contentType: AndroidContentType.music,
        usageType: AndroidUsageType.media,
        audioFocus: AndroidAudioFocus.none, 
      ),
    );
    AudioPlayer.global.setAudioContext(audioContext);

    // Landscape Mode & Fullscreen (Immersive)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // 👇 WAKELOCK HATAO TAAKI BATTERY BACHE 👇
    WakelockPlus.disable();

    // Wapas normal phone orientation aur UI
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    _videoController?.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> pickAndPlayFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
      allowMultiple: false,
    );

    if (result != null && result.files.single.path != null) {
      String pickedVideoCachePath = result.files.single.path!;
      String originalFileName = result.files.single.name; 
      String baseName = originalFileName.replaceAll("_MRB_Video.mp4", "");
      
      String downloadPath = "/storage/emulated/0/Download";
      File audioFileM4A = File("$downloadPath/${baseName}_MRB_Audio.m4a");
      
      if (await audioFileM4A.exists()) {
        setState(() => _statusText = "Loading Files...");

        await _videoController?.dispose();
        
        _videoController = VideoPlayerController.file(File(pickedVideoCachePath));
        await _videoController!.initialize();
        
        _videoController!.setVolume(0.0); // Video mute

        await _audioPlayer.setSourceDeviceFile(audioFileM4A.path);

        setState(() {
          _isPlaying = true;
          _showControls = false;
          _statusText = "Playing: $baseName";
        });

        // Sync delay: Pehle video, fir zara sa ruk kar audio
        await _videoController!.play();
        await Future.delayed(const Duration(milliseconds: 50)); 
        await _audioPlayer.resume();
        
      } else {
        setState(() {
          _statusText = "Audio nahi mili yahan:\n${audioFileM4A.path}";
        });
      }
    }
  }

  void togglePlayPause() {
    if (_videoController == null) return;

    if (_isPlaying) {
      _videoController!.pause();
      _audioPlayer.pause();
    } else {
      _videoController!.play();
      _audioPlayer.resume();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  void seekTo(double seconds) {
    if (_videoController == null) return;
    Duration newPos = Duration(seconds: seconds.toInt());
    
    _videoController!.seekTo(newPos);
    _audioPlayer.seek(newPos);
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) duration.inHours, minutes, seconds].join(':');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      body: GestureDetector(
        onTap: () {
          setState(() {
            _showControls = !_showControls;
          });
        },
        child: Stack(
          alignment: Alignment.center,
          children: [
            
            // --- LAYER 1: VIDEO SCREEN ---
            Center(
              child: _videoController != null && _videoController!.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.movie_creation_rounded, color: Colors.white24, size: 80),
                        const SizedBox(height: 20),
                        Text(
                          _statusText, 
                          style: const TextStyle(color: Colors.white70, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
            ),

            // --- LAYER 2: CONTROLS OVERLAY ---
            if (_showControls)
              Container(
                color: Colors.black54, 
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    
                    // TOP BAR
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 30),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.folder_open_rounded, color: Colors.white, size: 30),
                            onPressed: pickAndPlayFile,
                          ),
                        ],
                      ),
                    ),

                    // CENTER PLAY/PAUSE
                    if (_videoController != null && _videoController!.value.isInitialized)
                      IconButton(
                        icon: Icon(
                          _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                          color: Colors.white,
                          size: 80,
                        ),
                        onPressed: togglePlayPause,
                      ),

                    // BOTTOM SEEKBAR 
                    if (_videoController != null && _videoController!.value.isInitialized)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                        child: ValueListenableBuilder(
                          valueListenable: _videoController!,
                          builder: (context, VideoPlayerValue value, child) {
                            return Row(
                              children: [
                                Text(formatTime(value.position), style: const TextStyle(color: Colors.white)),
                                Expanded(
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      thumbColor: Colors.red,
                                      activeTrackColor: Colors.red,
                                      inactiveTrackColor: Colors.white30,
                                      trackHeight: 4.0,
                                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                                    ),
                                    child: Slider(
                                      min: 0.0,
                                      max: value.duration.inSeconds.toDouble() > 0 ? value.duration.inSeconds.toDouble() : 1.0,
                                      value: value.position.inSeconds.toDouble(),
                                      onChanged: (val) => seekTo(val),
                                    ),
                                  ),
                                ),
                                Text(formatTime(value.duration), style: const TextStyle(color: Colors.white)),
                              ],
                            );
                          },
                        ),
                      ),
                      
                    if (_videoController == null || !_videoController!.value.isInitialized)
                      const SizedBox(height: 80), 
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
