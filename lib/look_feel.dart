import 'package:flutter/material.dart';
import '../main.dart'; 
import 'package:shared_preferences/shared_preferences.dart'; 

class LookAndFeel extends StatelessWidget {
  const LookAndFeel({super.key});

  Future<void> changeThemeColor(Color newColor) async {
              appColorNotifier.value = newColor;

              //save
              final prefs = await SharedPreferences.getInstance();
              await prefs.setInt('app_theme_color', newColor.value);
            }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Look & Feel (Colors)", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white), // Back button white
      ),
      
      body: ListView(
        padding: const EdgeInsets.all(15.0),
        children: [
          const Text(
            "Select App Theme", 
            style: TextStyle(color: Colors.white54, fontSize: 16, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 20),

          // 👇 Yahan tere 10 VIP Colors hain
          _buildColorOption("MrbFlix Red (Netflix Vibe)", const Color(0xFFE50914)),
          _buildColorOption("Hacker Green (Terminal Vibe)", const Color(0xFF00E676)),
          _buildColorOption("Trust Blue (Pro SaaS)", const Color(0xFF2563EB)),
          _buildColorOption("Premium Purple (VIP)", const Color(0xFF8B5CF6)),
          _buildColorOption("Action Orange (Alerts)", const Color(0xFFF97316)),
          _buildColorOption("Alien Cream (Soft Yellow)", const Color(0xFFFEF08A)),
          _buildColorOption("Mint Green (Fresh)", const Color(0xFFA7F3D0)),
          _buildColorOption("Lavender (Hostinger Vibe)", const Color(0xFFDDD6FE)),
          _buildColorOption("Original MRB Blue", const Color(0xFFA8C7FA)),
          _buildColorOption("Dark Slate (Pure Tech)", const Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  // 👉 Yeh function list ke items banayega aur color badlega
  Widget _buildColorOption(String colorName, Color colorCode) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      // Gol chakkar mein color dikhega
      leading: CircleAvatar(backgroundColor: colorCode, radius: 22), 
      title: Text(
        colorName, 
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500)
      ),
      onTap: () {
        // Jadoo yahan ho raha hai! Color badal do
        appColorNotifier.value = colorCode; 
        changeThemeColor(colorCode);
        print("$colorName Selected!");
      },
    );
  }
}