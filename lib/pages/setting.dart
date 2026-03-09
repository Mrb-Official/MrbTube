import 'package:flutter/material.dart';
import '../main.dart';
import '../look_feel.dart'; 

class Setting extends StatelessWidget{
  const Setting({super.key});
 
 

@override
Widget build(BuildContext context){

return ValueListenableBuilder<Color>(
  valueListenable: appColorNotifier,
  builder: (context, mrbColor, child){




  return Scaffold(
     backgroundColor: Colors.black,
     appBar: AppBar(
      title: const Text("Settings", style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.black,
      ),//appbar

     //list view
     body: ListView(
      padding: const EdgeInsets.all(15.0),
      children: [
      //btteri card
       // _buildVipCard(),
        _buildBatteryCard(mrbColor),
        const SizedBox(height: 30),

        //options
        _buildListOptions(Icons.folder_outlined,"Download Directory", "select where to Store Videos"),
        const SizedBox(height: 20),
        _buildListOptions(Icons.palette_outlined,"Look & Feel", "Dark theme and color palette", () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LookAndFeel()),
          );
        }),
        const SizedBox(height: 20),
        _buildListOptions(Icons.terminal_outlined,"Custom commands", "Run yd-dlp commands"),
        const SizedBox(height: 20),
        _buildListOptions(Icons.view_agenda_outlined,"Interface & Interaction", "Configure before downloads"),
        const SizedBox(height: 20),
        _buildListOptions(Icons.android_outlined,"Android 11+ Support", "Run In android 11 to 17"),
        const SizedBox(height: 20),
        _buildListOptions(Icons.announcement_outlined,"Announcement", "lear about new annucemnets"),
        const SizedBox(height: 20),
        _buildListOptions(Icons.audio_file_rounded,"Audio Files", "Checkout your downlooaded audio filese"),
        const SizedBox(height: 20),
        _buildListOptions(Icons.cast_rounded,"Cast On Tv", "Watch Your Downloads on your T.V"),
        const SizedBox(height: 20),
        const Divider(color: Colors.white24),
        _buildListOptions(Icons.info_outlined,"About", "Version, Feedback, Auto Update"),
        
      ],//children
      ),//listview


);//scaffold
  },//builder
);//valuelistener
}// build method
       

    Widget _buildListOptions(IconData icon, String title, String subtitle, [VoidCallback? onTapAction]){
      return ListTile(
        leading: Icon(icon, color: Colors.white, size: 35),

        //main title
        title: Text(title,
              style: const TextStyle(color: Colors.white,fontSize: 24, fontWeight: FontWeight.w500)
          ),//title

        //subtitel
        subtitle: Text(subtitle,
              style: const TextStyle(color: Colors.grey,fontSize: 16, fontWeight: FontWeight.w300)
          ),//title

        //on tap
        onTap: () {

        if(onTapAction != null){
            onTapAction!();

        
        } else{
          print("$title is pressed");
        }
        },//on tap

        );//List title
  }//function of list

  Widget _buildBatteryCard (Color mrbColor) {
    return Card(
      elevation: 0,
      color:  mrbColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),),//shape
      child: Padding(
        padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Icon(
                Icons.battery_charging_full_rounded,
                color: Colors.black87,
                size: 30,
                ),//icon

              const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: const [
                        Text("Battery Configuration",
                         style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            ),//text style
                          ),//text

                        const SizedBox(height: 6),

                        Text("Ignore Battery Optimization For This app to download in Background",
                         style: TextStyle(
                            color: Colors.black87,
                            height: 1.3,
                            fontSize: 14,
                            ),//textstyle
                          ),//subtext


                    ],//children
                    ),//column
                  ),//expended
            ],//children
            ),//row
        ),//padding

      );//card
  }//battru build widget

}//class
 

