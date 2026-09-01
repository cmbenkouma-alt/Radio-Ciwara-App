import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../config/radio_config.dart';
import '../services/radio_service.dart';

class HomeScreen extends StatefulWidget { const HomeScreen({super.key}); @override State<HomeScreen> createState()=>_HomeScreenState(); }

class _HomeScreenState extends State<HomeScreen> {
  final RadioService radio=RadioService.instance;
  late final WebViewController player;
  bool loading=false;
  String status='Prêt à écouter la radio';

  @override void initState(){super.initState();
    player=WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0xFFF7F7F7))
      ..loadFlutterAsset('assets/caster_player.html');
    radio.player.onPlayerStateChanged.listen((s){if(!mounted)return;setState(()=>status=s==PlayerState.playing?'🔴 RADIO CIWARA — EN DIRECT':s==PlayerState.paused?'Radio en pause':'Prêt à écouter la radio');});
  }

  Future<void> toggle() async {if(loading)return;setState(()=>loading=true);try{if(radio.player.state==PlayerState.playing){await radio.pause();}else{await radio.play();}}catch(_){if(mounted){setState(()=>status='Flux natif indisponible — utilisez le lecteur principal ci-dessous.');ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Utilisez le lecteur Radio Ciwara intégré pour écouter le direct.')));}}finally{if(mounted)setState(()=>loading=false);}}
  Future<void> openUrl(String url) async {await player.loadRequest(Uri.parse(url));}
  @override void dispose(){radio.dispose();super.dispose();}

  @override Widget build(BuildContext context){
    const red=Color(0xFFEF2B2B);
    return Scaffold(
      appBar:AppBar(title:const Text('RADIO CIWARA',style:TextStyle(fontWeight:FontWeight.w900)),backgroundColor:const Color(0xFF111214),actions:[IconButton(onPressed:()=>showAboutDialog(context:context,applicationName:'Radio Ciwara 105.5 FM',applicationVersion:'1.1.0',applicationLegalese:'Bamako · Mali'),icon:const Icon(Icons.info_outline))]),
      body:ListView(padding:const EdgeInsets.fromLTRB(16,20,16,32),children:[
        Container(padding:const EdgeInsets.all(24),decoration:BoxDecoration(borderRadius:BorderRadius.circular(28),gradient:const LinearGradient(colors:[Color(0xFF17181A),Color(0xFF3A1113)]),border:Border.all(color:Colors.white10)),child:Column(children:[
          const Icon(Icons.mic_external_on_rounded,size:82,color:Colors.white),const SizedBox(height:16),
          const Text('RADIO CIWARA',style:TextStyle(fontSize:30,fontWeight:FontWeight.w900)),const SizedBox(height:4),
          const Text('105.5 FM · BAMAKO',style:TextStyle(color:Colors.white70,fontWeight:FontWeight.w700)),const SizedBox(height:22),
          Text(status,textAlign:TextAlign.center,style:const TextStyle(fontWeight:FontWeight.w800)),const SizedBox(height:14),
          SizedBox(width:double.infinity,height:56,child:FilledButton.icon(style:FilledButton.styleFrom(backgroundColor:red),onPressed:toggle,icon:loading?const SizedBox(width:20,height:20,child:CircularProgressIndicator(strokeWidth:2,color:Colors.white)):StreamBuilder<PlayerState>(stream:radio.player.onPlayerStateChanged,builder:(c,s)=>Icon(s.data==PlayerState.playing?Icons.stop_rounded:Icons.play_arrow_rounded)),label:StreamBuilder<PlayerState>(stream:radio.player.onPlayerStateChanged,builder:(c,s)=>Text(s.data==PlayerState.playing?'ARRÊTER':'ÉCOUTER EN DIRECT')))),
        ])),
        const SizedBox(height:18),
        const Text('LECTEUR RADIO CIWARA',style:TextStyle(fontSize:12,fontWeight:FontWeight.w900,color:red)),const SizedBox(height:8),
        Container(height:205,clipBehavior:Clip.antiAlias,decoration:BoxDecoration(color:Colors.white,borderRadius:BorderRadius.circular(16)),child:WebViewWidget(controller:player)),
        const SizedBox(height:22),
        _card(Icons.article_outlined,'CIWARA INFO','Le journal écrit de Radio Ciwara',()=>openUrl('${RadioConfig.websiteUrl}ciwara-info.html')),
        _card(Icons.live_tv_outlined,'CIWARA TV','Regardez la WebTV de Ciwara',()=>openUrl('${RadioConfig.websiteUrl}ciwara-tv.html')),
        _card(Icons.public,'SITE WEB','Actualités, programmes et direct',()=>openUrl(RadioConfig.websiteUrl)),
        _card(Icons.radio,'HIT RADIO MAROC','Écouter notre partenaire',()=>openUrl('${RadioConfig.partnerUrl}live/')),
      ]),
    );
  }
  Widget _card(IconData icon,String title,String sub,VoidCallback onTap)=>Card(color:Colors.white.withValues(alpha:.06),child:ListTile(leading:CircleAvatar(backgroundColor:const Color(0xFFEF2B2B),child:Icon(icon,color:Colors.white)),title:Text(title,style:const TextStyle(fontWeight:FontWeight.w800)),subtitle:Text(sub),trailing:const Icon(Icons.chevron_right),onTap:onTap));
}
