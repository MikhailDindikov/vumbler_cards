
import 'package:just_audio/just_audio.dart';

class VumblerMusic {
  static bool vumblerPl = false;
  static AudioPlayer vumblerMus = AudioPlayer();

  static Future<((int, int), List)?> goVumbMu(String name) async {
    VumblerMusic.vumblerPl = true;
    await vumblerMus.setLoopMode(LoopMode.one);
    await vumblerMus.setAsset(name);
    await vumblerMus.play();

    return ((1, 1), []);
  }

  static ((int, int), List)? musVumbOne(String name) {
    AudioPlayer()
      ..setAsset(name)
      ..play();

    return ((1, 1), []);
  }

  static Future<((int, int), List)?> stoVumbMu() async {
    VumblerMusic.vumblerPl = false;
    await vumblerMus.stop();
    VumblerMusic.vumblerMus = AudioPlayer();
    return ((1, 1), []);
  }
}
