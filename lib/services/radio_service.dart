import 'package:audioplayers/audioplayers.dart';
import '../config/radio_config.dart';

class RadioService {
  RadioService._();
  static final RadioService instance = RadioService._();

  final AudioPlayer player = AudioPlayer();

  Future<void> play() async {
    await player.setSource(
      UrlSource(RadioConfig.streamUrl),
    );
    await player.resume();
  }

  Future<void> pause() async {
    await player.pause();
  }

  Future<void> stop() async {
    await player.stop();
  }

  Future<void> dispose() async {
    await player.dispose();
  }
}
