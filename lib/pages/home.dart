import 'package:flutter/material.dart';
import 'package:serious_python/serious_python.dart';
import 'package:permission_handler/permission_handler.dart';
import 'player_page.dart'; 
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:flutter/services.dart';
import 'package:expressive_loading_indicator/expressive_loading_indicator.dart';
import 'setting.dart';
import '../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlAccapter = TextEditingController();
  
  bool isdownload = false;
  String? VideoUrl;
  String? VideoTitle;
  double downloadProgress = 0.0;

  @override
  Widget build(BuildContext context) {
      Color mrbColor = appColorNotifier.value;    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings_rounded, color: Colors.black),
          onPressed: () {
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Setting(),
                ),//material page route
              );//navigator
            print("Setting open");
          }, 
        ), 
        title: const Text("MrbTube", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: mrbColor,
        actions: [
          IconButton(
            icon: const Icon(Icons.terminal_rounded, color: Colors.black),
            onPressed: () {
              HapticFeedback.mediumImpact();
              print("terminla paste");
            }, 
          ), 
          IconButton(
            icon: const Icon(Icons.play_circle_outline_rounded, color: Colors.black, size: 30),
            onPressed: () {
              HapticFeedback.mediumImpact();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PlayerPage()),
              );
            },
          ) // IconButton (Play) khatam
        ], // AppBar actions khatam
      ), // AppBar khatam

      body: Stack(
        children: [
          // --- LAYER 1: MAIN PAGE ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 36.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Enter Youtube Video Url', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  const SizedBox(height: 30),

                  if(isdownload)
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2326),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
                        ]
                      ), // BoxDecoration khatam
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(VideoUrl != null)
                              Image.network(
                                VideoUrl!,
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ), // Image khatam

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${VideoTitle ?? ""} :  ${(downloadProgress * 100).toInt()}%",
                                style: const TextStyle(color: Colors.white, fontSize: 16),
                              ), // Text khatam
                            ), // Padding khatam

                            // Loading Progress Indicator
                            SizedBox(
                              width: double.infinity,
                              height: 8.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10), 
                                child: LinearProgressIndicator(
                                  year2023: false,
                                  value: downloadProgress > 0 ? downloadProgress : null, 
                                  color: const Color(0xFFA8C7FA),
                                  backgroundColor: Colors.white12,
                                  minHeight: 8.0,
                                ), // LinearProgressIndicator khatam
                              ), // ClipRRect (Progress line wala) khatam
                            ) // SizedBox (Progress line wala) khatam
                          ], // Column (Video Card ke andar) ke children khatam
                        ), // Column (Video Card ke andar) khatam
                      ), // ClipRRect (Video Card wala) khatam
                    ), // Container (Video Card wala) khatam

                  // URL Input Box
                  TextField(
                    decoration: const InputDecoration(
                      hintText: "Paste link here...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                    ), // InputDecoration khatam
                    controller: _urlAccapter,
                  ), // TextField khatam
                  const SizedBox(height: 500),
                ], // Main Column ke children khatam
              ), // Main Column khatam
            ), // SingleChildScrollView khatam
          ), // Padding khatam
          // LAYER 1 YAHAN KHATAM HUA

          // --- LAYER 2: TERE DONO BUTTONS ---
          Positioned( 
            bottom: 30, 
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                
                // PEHLA BUTTON (Paste)
                Container(
                  height: 60, width: 60, 
                  decoration: BoxDecoration(
                    color: mrbColor,
                    borderRadius: BorderRadius.circular(12), 
                  ), // BoxDecoration khatam
                  child: IconButton(
                    icon: const Icon(Icons.content_paste_rounded, color: Colors.black),
                    onPressed: () async {
                      ClipboardData? copyData = await Clipboard.getData(Clipboard.kTextPlain);
                      HapticFeedback.mediumImpact(); //vibration
                      if(copyData !=null && copyData.text != null){
                        setState((){
                          _urlAccapter.text = copyData.text!;
                        });//setstate
                      }//if
                      
                      print("terminla paste");
                    }, // onPressed khatam
                  ), // IconButton khatam
                ), // Container (Paste Button wala) khatam

                const SizedBox(height: 15), 

                // DOOSRA BUTTON (Download)
                Container(
                  height: 60, width: 60,
                  decoration: BoxDecoration(
                    color: mrbColor,
                    borderRadius: BorderRadius.circular(12),
                    //boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 6, offset: Offset(0, 3))]
                  ), // BoxDecoration khatam
                  child: IconButton(
                    icon: const Icon(Icons.download_rounded, color: Colors.black87),
                    onPressed: () async {
                      HapticFeedback.mediumImpact(); //for vibration
                      setState(() {
                        isdownload = true;
                        downloadProgress = 0.0; 
                        VideoUrl = "https://upload.wikimedia.org/wikipedia/commons/b/b1/Loading_icon.gif"; 
                        VideoTitle = "Fetching Video Details...";
                      });

                      var status = await Permission.manageExternalStorage.request();
                      String vurl = _urlAccapter.text.trim();

                      if (vurl.isNotEmpty && status.isGranted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Downloading Raw Files...")),
                        );
                        
                        try {
                          //fetch thumbnail and title
                          var yt = YoutubeExplode();
                          var video = await yt.videos.get(vurl);

                          setState((){
                            VideoUrl = video.thumbnails.highResUrl;
                            VideoTitle = video.title;
                          });

                          yt.close();//close aftet fetch 

                          // Cache setup
                          Directory cacheDir = await getTemporaryDirectory();
                          File progressFile = File('${cacheDir.path}/progress.txt');

                          if (await progressFile.exists()) {
                            await progressFile.delete();
                          }

                          // Jasoos Timer
                          Timer.periodic(const Duration(seconds: 1), (timer) async {
                            if (await progressFile.exists()) {
                              String data = await progressFile.readAsString();
                              
                              if (data.isNotEmpty) {
                                double percent = double.tryParse(data) ?? 0.0;
                                
                                setState(() {
                                  downloadProgress = percent / 100; 
                                });

                                if (percent >= 100.0) {
                                  timer.cancel(); 
                                  await progressFile.delete(); 
                                } // if (percent >= 100.0) khatam
                              } // if (data.isNotEmpty) khatam
                            } // if (await progressFile.exists()) khatam
                          }); // Timer khatam
                          
                          // Python Script Run
                          await SeriousPython.run(
                            "app/app.zip",
                            environmentVariables: {
                              "VIDEO_URL": vurl,
                              "APP_CACHE_PATH": cacheDir.path 
                            },
                          ); // SeriousPython.run khatam
                          
                          // Download hone ke baad UI update
                          setState(() {
                            isdownload = false;
                            downloadProgress = 0.0;
                          });
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("✅ Download Complete! Saved in Downloads.")),
                          );
                        } catch (e) {
                          print("Error: $e");
                        } // try-catch khatam
                      } else if (vurl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("⚠️ Please Enter A URL First")),
                        );
                      } // if-else block khatam
                    }, // onPressed khatam
                  ), // IconButton (Download Button wala) khatam
                ), // Container (Download Button wala) khatam
              ], // Column (Buttons ke liye) ke children khatam
            ), // Column (Buttons ke liye) khatam
          ), // Positioned khatam
        ], // Stack ke children khatam
      ), // Stack khatam
    ); // Scaffold khatam
  } // build method khatam
} // _HomePageState khatam