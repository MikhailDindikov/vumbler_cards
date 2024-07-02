import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';

class VumblerTextures {
  static final vumbSymbols = ['6', '7', '8', '9', '10', 'j', 'q', 'k', 't'];
  static late ui.Image vumblerShader;
  static late ui.Image vumblerCard;
  static List<ui.Image> vumblerColors = [];
  static List<ui.Image> vumblerSymbols = [];
  static late Random vumblerRandom;
  static late num vumbZoom;

  static Future<void> loadVumblerTextures() async {
    vumblerRandom = Random();
    vumbZoom = await MethodChannel('flutter_zoom_checker').invokeMethod<num>('getDisplayZoom') ?? 1;
    vumblerShader = await _getVumblerResource('cassets/frames/mask.png');
    vumblerCard = await _getVumblerResource('cassets/game/card.png');
    vumblerColors
        .add(await _getVumblerResource('cassets/game/strokes/blue.png'));
    vumblerColors
        .add(await _getVumblerResource('cassets/game/strokes/red.png'));
    vumblerColors
        .add(await _getVumblerResource('cassets/game/strokes/yellow.png'));
    vumblerSymbols
        .add(await _getVumblerResource('cassets/game/figures/b_s.png'));
    vumblerSymbols
        .add(await _getVumblerResource('cassets/game/figures/ch_s.png'));
    vumblerSymbols
        .add(await _getVumblerResource('cassets/game/figures/kr_s.png'));
    vumblerSymbols
        .add(await _getVumblerResource('cassets/game/figures/p_s.png'));
  }

  static Future<ui.Image> _getVumblerResource(String resPath) async {
    final dataFabVumbler = await rootBundle.load(resPath);
    final listFaaVumbler = Uint8List.view(dataFabVumbler.buffer);
    final completerFabVumbler = Completer<ui.Image>();
    ui.decodeImageFromList(listFaaVumbler, completerFabVumbler.complete);
    return completerFabVumbler.future;
  }
}
