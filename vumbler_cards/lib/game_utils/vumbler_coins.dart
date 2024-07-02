import 'package:get/get.dart';
import 'package:vumbler_cards/game_utils/vumbler_storage.dart';

class VumblerCoins {
  static late RxInt vumblerCoins;

  static void vumblerCoinsInit() {
    vumblerCoins = (VumblerStorage.vumblerStorage!.getInt('vumbCoins') ?? 0).obs;
  }

  static void plusMinusCoins(int setOnCoins) {
    vumblerCoins.value += setOnCoins;
    VumblerStorage.vumblerStorage!.setInt('vumbCoins', vumblerCoins.value);
  }
}
