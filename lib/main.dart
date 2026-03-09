import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:shared_preferences/shared_preferences.dart';

   final  ValueNotifier<Color> appColorNotifier = ValueNotifier(const Color(0xFFA8C7FA)); //GLOAL VARIALBLE FOR THEME IDENTIFY
   Future<void>main() async {
  WidgetsFlutterBinding.ensureInitialized();

    //saved color load
    final prefs = await SharedPreferences.getInstance();
    final savedColor = prefs.getInt('app_theme_color');

    if(savedColor != null){
      appColorNotifier.value = Color(savedColor);
    }
  

     runApp(const MyApp()); // ← yahan move kiya
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Color>(
      valueListenable: appColorNotifier,

      builder: (context, currentColor, child){
      
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mrb Tube',
      theme: ThemeData(
        useMaterial3: true,
        
        colorScheme: ColorScheme.fromSeed(
          seedColor: currentColor,
          brightness: Brightness.dark,
          ),
      ),
      home: HomePage(),
    );

  },//builder
  );//lilstener
  }//widget
}//class