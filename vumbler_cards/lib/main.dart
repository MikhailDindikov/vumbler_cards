import 'package:apphud/apphud.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vumbler_cards/game_frames/main_vumb_frame.dart';
import 'package:vumbler_cards/game_utils/vumbler_coins.dart';
import 'package:vumbler_cards/game_utils/vumbler_music.dart';
import 'package:vumbler_cards/game_utils/vumbler_storage.dart';
import 'package:vumbler_cards/game_utils/vumbler_textures.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await VumblerStorage.vumbler();
  // await VumblerStorage.vumblerStorage!.clear();
  // await VumblerStorage.vumblerStorage!.setInt('vumbCoins', 400);
  await VumblerTextures.loadVumblerTextures();
  await Apphud.start(apiKey: 'app_EXNbEAQ8UsRuYzp3VGvdwMDdGeLATt');
  final zoom = await MethodChannel('flutter_zoom_checker').invokeMethod<num>('getDisplayZoom');
  print(zoom);
  VumblerCoins.vumblerCoinsInit();
  runApp(const MyVumbler());
}

class MyVumbler extends StatelessWidget {
  const MyVumbler({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vumbler Cards',
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StatefulBuilder(builder: (_, func) {
        final vumbMusCont = Get.put(VumbMusCont());
        return GetBuilder<VumbMusCont>(builder: (__) {
          return MediaQuery.withNoTextScaling(
            child: const MainVumbFrame(),
          );
        });
      }),
    );
  }
}

class VumbMusCont extends FullLifeCycleController with FullLifeCycleMixin {
  @override
  void onDetached() {}

  @override
  void onInactive() {
    if (VumblerMusic.vumblerPl) {
      VumblerMusic.stoVumbMu();
    }
  }

  @override
  void onPaused() {}

  @override
  void onResumed() {
    if ((VumblerStorage.vumblerStorage!.getBool('vumbMu') ?? true)) {
      VumblerMusic.goVumbMu('cassets/back.mp3');
    }
  }

  @override
  void onHidden() {}
}
