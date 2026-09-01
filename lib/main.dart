import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main(){WidgetsFlutterBinding.ensureInitialized();runApp(const RadioCiwaraApp());}

class RadioCiwaraApp extends StatelessWidget{
  const RadioCiwaraApp({super.key});
  @override
  Widget build(BuildContext context)=>MaterialApp(
    debugShowCheckedModeBanner:false,
    title:'Radio Ciwara 105.5 FM',
    theme:ThemeData(useMaterial3:true,brightness:Brightness.dark,scaffoldBackgroundColor:const Color(0xFF111214),colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xFFEF2B2B),brightness:Brightness.dark)),
    home:const HomeScreen(),
  );
}
