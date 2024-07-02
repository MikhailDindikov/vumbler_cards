import 'dart:ui' as ui;

import 'package:vumbler_cards/game_utils/vumbler_textures.dart';

class VumblerGameModel {
  final String vumbType;
  final ui.Image vumbSymbol;
  final ui.Image vumbColor;
  final int vumbTypeInd;
  final int vumbSymbolInd;
  final int vumbColorInd;

  const VumblerGameModel({
    required this.vumbType,
    required this.vumbSymbol,
    required this.vumbColor,
    required this.vumbTypeInd,
    required this.vumbSymbolInd,
    required this.vumbColorInd,
  });

  factory VumblerGameModel.generate() {
    final vumbTypeInd = VumblerTextures.vumblerRandom
        .nextInt(VumblerTextures.vumbSymbols.length - 1);
    final vumbSymbolInd = VumblerTextures.vumblerRandom
        .nextInt(VumblerTextures.vumblerSymbols.length);
    final vumbColorInd = VumblerTextures.vumblerRandom
        .nextInt(VumblerTextures.vumblerColors.length);
    print(vumbTypeInd);
    print(vumbSymbolInd);
    print(vumbColorInd);
    return VumblerGameModel(
      vumbType: VumblerTextures.vumbSymbols[vumbTypeInd],
      vumbSymbol: VumblerTextures.vumblerSymbols[vumbSymbolInd],
      vumbColor: VumblerTextures.vumblerColors[vumbColorInd],
      vumbTypeInd: vumbTypeInd,
      vumbSymbolInd: vumbSymbolInd,
      vumbColorInd: vumbColorInd,
    );
  }
}
