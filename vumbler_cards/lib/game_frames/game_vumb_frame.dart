import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as image;
import 'package:vumbler_cards/game_frames/main_vumb_frame.dart';
import 'package:vumbler_cards/game_utils/vumbler_coins.dart';
import 'package:vumbler_cards/game_utils/vumbler_music.dart';
import 'package:vumbler_cards/game_utils/vumbler_storage.dart';
import 'package:vumbler_cards/game_utils/vumbler_textures.dart';
import 'package:vumbler_cards/vumbler_models.dart/vumbler_game_model.dart';

class GameVumbFrame extends StatefulWidget {
  final String vumbType;
  final int vumbMaxLoses;
  const GameVumbFrame(
      {required this.vumbType, required this.vumbMaxLoses, super.key});

  @override
  State<GameVumbFrame> createState() => _GameVumbFrameState();
}

class _GameVumbFrameState extends State<GameVumbFrame>
    with TickerProviderStateMixin {
  final vumbSelected = VumblerStorage.vumblerStorage!.getInt('vumbSel') ?? 0;

  int vumbStart = 5000;
  RxInt curVumbScore = 0.obs;
  RxInt vumbColorInd = 0.obs;
  RxInt vumbSymbolInd = 0.obs;
  RxInt vumbTypeInd = 0.obs;
  bool isVumbAnimate = false;
  bool vumbPause = false;
  RxInt vumbLoses = 0.obs;
  int vumbStage = 0;
  RxInt vumbMs = 5000.obs;
  RxInt vumbAll = 5000.obs;
  Timer? vumbTimer;
  RxBool showTop = false.obs;
  RxBool showMid = false.obs;
  bool removeTop = false;
  Rx<VumblerGameModel> vumbCurModel = VumblerGameModel.generate().obs;

  final vumbTopKey = GlobalKey<SnappableState>();
  final vumbMidKey = GlobalKey<SnappableState>();
  late final vumbTopContr = AnimationController(vsync: this);
  late final vumbMidContr = AnimationController(vsync: this);

  Future<void> vumbSnap() async {
    isVumbAnimate = true;
    if (!removeTop) {
      vumbLoses.value++;
    }
    vumbTopContr.forward();
    vumbMidContr.forward();
    await Future.delayed(100.ms);
    if (!removeTop) {
      vumbMidKey.currentState!.snap();
      await Future.delayed(500.ms);
      VumblerMusic.musVumbOne('cassets/unlu.mp3');
      showMid.value = false;
    } else {
      curVumbScore.value++;
      vumbTopKey.currentState!.snap();
      await Future.delayed(500.ms);
      VumblerMusic.musVumbOne('cassets/lu.mp3');
      showTop.value = false;
    }
    vumbStage++;
    vumbAll.value = vumbStart - vumbStage * 100;
    vumbMs.value = vumbStart - vumbStage * 100;
    if (vumbLoses.value == widget.vumbMaxLoses) {
      vumb_game_over();
      vumbTimer?.cancel();
      return;
    }
  }

  void vumbReset() {
    vumbTimer?.cancel();
    curVumbScore.value = 0;
    vumbColorInd.value = 0;
    vumbSymbolInd.value = 0;
    vumbTypeInd.value = 0;
    isVumbAnimate = false;
    vumbLoses.value = 0;
    vumbStage = 0;
    vumbMs.value = 5000;
    vumbAll.value = 5000;
    showTop.value = false;
    showMid.value = false;
    removeTop = false;
    vumbCurModel.value = VumblerGameModel.generate();
    vumbPause = false;
    showMid.value = true;
    showTop.value = true;
    vumbTimer = Timer.periodic(10.ms, (timer) {
      if (!isVumbAnimate && vumbMs.value > 0 && !vumbPause) {
        vumbMs.value -= 10;
        if (vumbMs.value == 0) {
          removeTop = vumbColorInd.value == vumbCurModel.value.vumbColorInd &&
              vumbSymbolInd.value == vumbCurModel.value.vumbSymbolInd &&
              vumbTypeInd.value == vumbCurModel.value.vumbTypeInd + 1;
          if (!isVumbAnimate) {
            vumbSnap();
          }
        }
      }
    });
    Get.back();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (VumblerStorage.vumblerStorage!.getBool('vumbRules') ?? true) {
        vumbPause = true;
        vumb_info();
        VumblerStorage.vumblerStorage!.setBool('vumbRules', false);
      }
      showMid.value = true;
      showTop.value = true;
      vumbTimer = Timer.periodic(10.ms, (timer) {
        if (!isVumbAnimate && vumbMs.value > 0 && !vumbPause) {
          vumbMs.value -= 10;
          if (vumbMs.value == 0) {
            removeTop = vumbColorInd.value == vumbCurModel.value.vumbColorInd &&
                vumbSymbolInd.value == vumbCurModel.value.vumbSymbolInd &&
                vumbTypeInd.value == vumbCurModel.value.vumbTypeInd + 1;
            if (!isVumbAnimate) {
              vumbSnap();
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    vumbTimer?.cancel();
  }

  vumb_info() {
    vumbPause = true;
    return showDialog(
      context: context,
      barrierColor: Color.fromRGBO(2, 5, 82, 0.8),
      builder: (context) => IntrinsicHeight(
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: (204 + 50) / VumblerTextures.vumbZoom,
                margin: EdgeInsets.symmetric(
                    horizontal: 14 / VumblerTextures.vumbZoom),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -17 / VumblerTextures.vumbZoom,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'cassets/frames/header.png',
                            height: 49 / VumblerTextures.vumbZoom,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 3.0 / VumblerTextures.vumbZoom),
                            child: Text(
                              'rulEs'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16 / VumblerTextures.vumbZoom,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'cassets/frames/mini_dial.png',
                          height: 204 / VumblerTextures.vumbZoom,
                        ),
                        SizedBox(
                          width: 204 / VumblerTextures.vumbZoom,
                          child: Text(
                            '''Tap on the decks below
and create a card of the matching color and suit,
but with a 1 level higher in order to defeat the card on top.''',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14 / VumblerTextures.vumbZoom,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: -12 / VumblerTextures.vumbZoom,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          'cassets/buttons/close.png',
                          height: 52 / VumblerTextures.vumbZoom,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      vumbPause = false;
    });
  }

  vumb_settings() {
    vumbPause = true;
    RxBool vumbMus =
        (VumblerStorage.vumblerStorage!.getBool('vumbMu') ?? true).obs;
    return showDialog(
      context: context,
      barrierColor: Color.fromRGBO(2, 5, 82, 0.8),
      builder: (context) => IntrinsicHeight(
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: (204 + 50) / VumblerTextures.vumbZoom,
                margin: EdgeInsets.symmetric(
                    horizontal: 14 / VumblerTextures.vumbZoom),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: -17 / VumblerTextures.vumbZoom,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'cassets/frames/header.png',
                            height: 49 / VumblerTextures.vumbZoom,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                bottom: 3.0 / VumblerTextures.vumbZoom),
                            child: Text(
                              'SettinGs'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16 / VumblerTextures.vumbZoom,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        Image.asset(
                          'cassets/frames/mini_dial.png',
                          height: 204 / VumblerTextures.vumbZoom,
                        ),
                        SizedBox(
                          width: 204 / VumblerTextures.vumbZoom,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  vumbMus.toggle();
                                  VumblerStorage.vumblerStorage!
                                      .setBool('vumbMu', vumbMus.value);
                                  if (vumbMus.value == true) {
                                    VumblerMusic.goVumbMu('cassets/back.mp3');
                                  } else {
                                    VumblerMusic.stoVumbMu();
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Music'.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize:
                                              20 / VumblerTextures.vumbZoom,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    SizedBox(
                                      width: 10 / VumblerTextures.vumbZoom,
                                    ),
                                    Obx(
                                      () => vumbMus.value
                                          ? Image.asset(
                                              'cassets/buttons/on.png',
                                              height:
                                                  21 / VumblerTextures.vumbZoom,
                                            )
                                          : Image.asset(
                                              'cassets/buttons/off.png',
                                              height:
                                                  21 / VumblerTextures.vumbZoom,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20 / VumblerTextures.vumbZoom,
                              ),
                              GestureDetector(
                                onTap: vumbReset,
                                child: Text(
                                  'restArt'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20 / VumblerTextures.vumbZoom,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                              SizedBox(
                                height: 20 / VumblerTextures.vumbZoom,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.offAll(() => MainVumbFrame());
                                },
                                child: Text(
                                  'back to Menu'.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20 / VumblerTextures.vumbZoom,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: -12 / VumblerTextures.vumbZoom,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Image.asset(
                          'cassets/buttons/close.png',
                          height: 52 / VumblerTextures.vumbZoom,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      vumbPause = false;
    });
  }

  vumb_game_over() {
    VumblerCoins.plusMinusCoins(curVumbScore.value);
    final vumbCurMax =
        VumblerStorage.vumblerStorage!.getInt('vumbRec_${widget.vumbType}') ??
            0;
    if (curVumbScore.value > vumbCurMax) {
      VumblerStorage.vumblerStorage!
          .setInt('vumbRec_${widget.vumbType}', curVumbScore.value);
    }
    vumbPause = true;
    return showDialog(
      context: context,
      barrierColor: Color.fromRGBO(2, 5, 82, 0.8),
      builder: (context) => IntrinsicHeight(
        child: Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'cassets/game/game_over.png',
                    width: 309 / VumblerTextures.vumbZoom,
                  ),
                  Positioned(
                    bottom: 94,
                    child: Text(
                      'SCORES: ${curVumbScore.value}',
                      style: TextStyle(
                        fontSize: 14 / VumblerTextures.vumbZoom,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 40 / VumblerTextures.vumbZoom,
              ),
              GestureDetector(
                onTap: vumbReset,
                child: Image.asset(
                  'cassets/buttons/retry.png',
                  height: 60 / VumblerTextures.vumbZoom,
                ),
              ),
              SizedBox(
                height: 29 / VumblerTextures.vumbZoom,
              ),
              GestureDetector(
                onTap: () {
                  Get.offAll(() => MainVumbFrame());
                },
                child: Image.asset(
                  'cassets/buttons/back.png',
                  height: 60 / VumblerTextures.vumbZoom,
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      vumbPause = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                'cassets/frames/${vumbSelected == 0 ? 'default' : vumbSelected == 1 ? 'tech' : vumbSelected == 2 ? 'cosmo' : vumbSelected == 3 ? 'north' : vumbSelected == 4 ? 'fractal' : 'ice'}.png'),
            fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 16 / VumblerTextures.vumbZoom,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 28 / VumblerTextures.vumbZoom),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: vumb_info,
                            child: Image.asset(
                              'cassets/buttons/info_circle.png',
                              height: 40 / VumblerTextures.vumbZoom,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20 / VumblerTextures.vumbZoom),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'cassets/buttons/scores.png',
                                  height: 81 / VumblerTextures.vumbZoom,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: 20 / VumblerTextures.vumbZoom),
                                  child: ShaderMask(
                                    blendMode: BlendMode.srcATop,
                                    shaderCallback: (bounds) {
                                      final vumbscaleX = bounds.width /
                                          VumblerTextures.vumblerShader.width;
                                      final vumbscaleY = bounds.height /
                                          VumblerTextures.vumblerShader.height;
                                      final vumbscale =
                                          max(vumbscaleX, vumbscaleY);
                                      final vumbscaledImageWidth =
                                          VumblerTextures.vumblerShader.width *
                                              vumbscale;
                                      final vumbsacledImageHeight =
                                          VumblerTextures.vumblerShader.height *
                                              vumbscale;
                                      final offset = Offset(
                                        (vumbscaledImageWidth - bounds.width) /
                                            2,
                                        (vumbsacledImageHeight -
                                                bounds.height) /
                                            2,
                                      );
                                      final vumbmatrix = Matrix4.identity()
                                        // Scale image
                                        //..scale(vumbscale, vumbscale)
                                        ..leftTranslate(
                                          -offset.dx,
                                          -offset.dy,
                                        );
                                      return ImageShader(
                                        VumblerTextures.vumblerShader,
                                        TileMode.clamp,
                                        TileMode.clamp,
                                        vumbmatrix.storage,
                                      );
                                    },
                                    child: Obx(
                                      () => Text(
                                        curVumbScore.value.toString(),
                                        style: TextStyle(
                                          fontSize:
                                              25 / VumblerTextures.vumbZoom,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: vumb_settings,
                            child: Image.asset(
                              'cassets/buttons/settings_circle.png',
                              height: 40 / VumblerTextures.vumbZoom,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 31,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'cassets/game/timeline.png',
                          width: 222 / VumblerTextures.vumbZoom,
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              top: 1.5 / VumblerTextures.vumbZoom),
                          height: 16 / VumblerTextures.vumbZoom,
                          width: 200 / VumblerTextures.vumbZoom,
                          alignment: Alignment.centerLeft,
                          child: Obx(
                            () => AnimatedContainer(
                              duration: 10.ms,
                              width: ((vumbMs.value == 0
                                          ? 0
                                          : vumbMs.value / vumbAll.value) *
                                      200) /
                                  VumblerTextures.vumbZoom,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color.fromRGBO(0, 110, 173, 1),
                                    Color.fromRGBO(8, 164, 255, 1),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 36 / VumblerTextures.vumbZoom,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.vumbMaxLoses > 4)
                          Obx(
                            () => AnimatedOpacity(
                              duration: 1000.ms,
                              opacity: vumbLoses.value < 5 ? 1 : 0,
                              child: Image.asset(
                                'cassets/game/star.png',
                                width: 25 / VumblerTextures.vumbZoom,
                              ),
                            ),
                          ),
                        if (widget.vumbMaxLoses > 4)
                          SizedBox(width: 4 / VumblerTextures.vumbZoom),
                        if (widget.vumbMaxLoses > 3)
                          Obx(
                            () => AnimatedOpacity(
                              duration: 1000.ms,
                              opacity: vumbLoses.value < 4 ? 1 : 0,
                              child: Image.asset(
                                'cassets/game/star.png',
                                width: 25 / VumblerTextures.vumbZoom,
                              ),
                            ),
                          ),
                        if (widget.vumbMaxLoses > 3)
                          SizedBox(width: 4 / VumblerTextures.vumbZoom),
                        Obx(
                          () => AnimatedOpacity(
                            duration: 1000.ms,
                            opacity: vumbLoses.value < 3 ? 1 : 0,
                            child: Image.asset(
                              'cassets/game/star.png',
                              width: 25 / VumblerTextures.vumbZoom,
                            ),
                          ),
                        ),
                        SizedBox(width: 4 / VumblerTextures.vumbZoom),
                        Obx(
                          () => AnimatedOpacity(
                            duration: 1000.ms,
                            opacity: vumbLoses.value < 2 ? 1 : 0,
                            child: Image.asset(
                              'cassets/game/star.png',
                              width: 25 / VumblerTextures.vumbZoom,
                            ),
                          ),
                        ),
                        SizedBox(width: 4 / VumblerTextures.vumbZoom),
                        Obx(
                          () => AnimatedOpacity(
                            duration: 1000.ms,
                            opacity: vumbLoses.value < 1 ? 1 : 0,
                            child: Image.asset(
                              'cassets/game/star.png',
                              width: 25 / VumblerTextures.vumbZoom,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 12 / VumblerTextures.vumbZoom,
                    ),
                    Obx(
                      () => AnimatedOpacity(
                        duration: 500.ms,
                        opacity: showTop.value ? 1 : 0.2,
                        child: Container(
                          height: 107 / VumblerTextures.vumbZoom,
                          width: 84 / VumblerTextures.vumbZoom,
                          child: Snappable(
                            key: vumbTopKey,
                            duration: 1000.ms,
                            onSnapped: () {
                              vumbCurModel.value = VumblerGameModel.generate();
                              isVumbAnimate = false;
                              showTop.value = true;
                              vumbTopKey.currentState!.reset();
                            },
                            child: Center(
                              child: Obx(
                                () => VumbGameCardTop(
                                  vumbModel: vumbCurModel.value,
                                ),
                              ),
                            ),
                          ),
                        )
                            .animate(
                              autoPlay: false,
                              controller: vumbTopContr,
                              onComplete: (controller) async {
                                await Future.delayed(1000.ms);
                                vumbTopContr.reset();
                              },
                            )
                            .move(
                                duration: 250.ms,
                                curve: Curves.bounceInOut,
                                begin: Offset.zero,
                                end: Offset(0, 29 / VumblerTextures.vumbZoom))
                            .move(
                                delay: 250.ms,
                                curve: Curves.bounceInOut,
                                begin: Offset.zero,
                                end: Offset(0, -29 / VumblerTextures.vumbZoom)),
                      ),
                    ),
                    SizedBox(
                      height: 58 / VumblerTextures.vumbZoom,
                    ),
                    Obx(
                      () => AnimatedOpacity(
                        duration: 500.ms,
                        opacity: showMid.value ? 1 : 0.2,
                        child: Container(
                          height: 107 / VumblerTextures.vumbZoom,
                          width: 84 / VumblerTextures.vumbZoom,
                          child: Snappable(
                            key: vumbMidKey,
                            duration: 1000.ms,
                            onSnapped: () {
                              vumbCurModel.value = VumblerGameModel.generate();
                              isVumbAnimate = false;
                              showMid.value = true;
                              vumbMidKey.currentState!.reset();
                            },
                            child: Center(
                              child: GestureDetector(
                                onTap: () async {},
                                child: Container(
                                  height: 107 / VumblerTextures.vumbZoom,
                                  width: 84 / VumblerTextures.vumbZoom,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Color.fromRGBO(
                                              34, 185, 218, 0.25),
                                          blurRadius: 8),
                                      BoxShadow(
                                          color:
                                              Color.fromRGBO(34, 185, 218, 0.6),
                                          blurRadius: 12),
                                    ],
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        'cassets/game/card.png',
                                        width: 84 / VumblerTextures.vumbZoom,
                                      ),
                                      Obx(
                                        () => RawImage(
                                          image: VumblerTextures.vumblerColors[
                                              vumbColorInd.value],
                                          width: 84 / VumblerTextures.vumbZoom,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: 8 / VumblerTextures.vumbZoom,
                                            bottom:
                                                15 / VumblerTextures.vumbZoom),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Image.asset(
                                                  'cassets/game/type_bg.png',
                                                  height: 36 /
                                                      VumblerTextures.vumbZoom,
                                                ),
                                                Obx(
                                                  () => Text(
                                                    VumblerTextures.vumbSymbols[
                                                            vumbTypeInd.value]
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      fontSize: 24 /
                                                          VumblerTextures
                                                              .vumbZoom,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Obx(
                                              () => RawImage(
                                                image: VumblerTextures
                                                        .vumblerSymbols[
                                                    vumbSymbolInd.value],
                                                width: 48 /
                                                    VumblerTextures.vumbZoom,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                            .animate(
                              autoPlay: false,
                              controller: vumbMidContr,
                              onComplete: (controller) async {
                                // vumbMidKey.currentState!.snap();
                                await Future.delayed(1000.ms);
                                vumbMidContr.reset();
                              },
                            )
                            .move(
                                duration: 250.ms,
                                curve: Curves.bounceInOut,
                                begin: Offset.zero,
                                end: Offset(0, -29 / VumblerTextures.vumbZoom))
                            .move(
                                delay: 250.ms,
                                curve: Curves.bounceInOut,
                                begin: Offset.zero,
                                end: Offset(0, 29 / VumblerTextures.vumbZoom)),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Column(
                    children: [
                      FittedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                if (!isVumbAnimate && vumbMs.value != 0) {
                                  VumblerMusic.musVumbOne('cassets/tap.mp3');
                                  if (vumbColorInd.value == 2) {
                                    vumbColorInd.value = 0;
                                  } else {
                                    vumbColorInd.value++;
                                  }
                                }
                              },
                              child: Container(
                                height: 107 / VumblerTextures.vumbZoom,
                                width: 84 / VumblerTextures.vumbZoom,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'cassets/game/card.png',
                                      width: 84 / VumblerTextures.vumbZoom,
                                    ),
                                    Obx(
                                      () => RawImage(
                                        image: VumblerTextures
                                            .vumblerColors[vumbColorInd.value],
                                        width: 84 / VumblerTextures.vumbZoom,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 35 / VumblerTextures.vumbZoom,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!isVumbAnimate && vumbMs.value != 0) {
                                  VumblerMusic.musVumbOne('cassets/tap.mp3');
                                  if (vumbSymbolInd.value == 3) {
                                    vumbSymbolInd.value = 0;
                                  } else {
                                    vumbSymbolInd.value++;
                                  }
                                }
                              },
                              child: Container(
                                height: 107 / VumblerTextures.vumbZoom,
                                width: 84 / VumblerTextures.vumbZoom,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'cassets/game/card.png',
                                      width: 84 / VumblerTextures.vumbZoom,
                                    ),
                                    Obx(
                                      () => RawImage(
                                        image: VumblerTextures.vumblerSymbols[
                                            vumbSymbolInd.value],
                                        width: 76 / VumblerTextures.vumbZoom,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 35 / VumblerTextures.vumbZoom,
                            ),
                            GestureDetector(
                              onTap: () {
                                if (!isVumbAnimate && vumbMs.value != 0) {
                                  VumblerMusic.musVumbOne('cassets/tap.mp3');
                                  if (vumbTypeInd.value == 8) {
                                    vumbTypeInd.value = 0;
                                  } else {
                                    vumbTypeInd.value++;
                                  }
                                }
                              },
                              child: Container(
                                height: 107 / VumblerTextures.vumbZoom,
                                width: 84 / VumblerTextures.vumbZoom,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Image.asset(
                                      'cassets/game/card.png',
                                      width: 84 / VumblerTextures.vumbZoom,
                                    ),
                                    Obx(
                                      () => Text(
                                        VumblerTextures
                                            .vumbSymbols[vumbTypeInd.value]
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize:
                                              64 / VumblerTextures.vumbZoom,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16 / VumblerTextures.vumbZoom,
                      ),
                    ],
                    mainAxisAlignment: MainAxisAlignment.end,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class VumbGameCardTop extends StatelessWidget {
  final VumblerGameModel vumbModel;
  const VumbGameCardTop({required this.vumbModel, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 107 / VumblerTextures.vumbZoom,
      width: 84 / VumblerTextures.vumbZoom,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(34, 185, 218, 0.25), blurRadius: 8),
          BoxShadow(color: Color.fromRGBO(34, 185, 218, 0.6), blurRadius: 12),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'cassets/game/card.png',
            width: 84 / VumblerTextures.vumbZoom,
          ),
          RawImage(
            image: vumbModel.vumbColor,
            width: 84 / VumblerTextures.vumbZoom,
          ),
          Padding(
            padding: EdgeInsets.only(
                top: 8 / VumblerTextures.vumbZoom,
                bottom: 15 / VumblerTextures.vumbZoom),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'cassets/game/type_bg.png',
                      height: 36 / VumblerTextures.vumbZoom,
                    ),
                    Text(
                      vumbModel.vumbType.toUpperCase(),
                      style: TextStyle(
                        fontSize: 24 / VumblerTextures.vumbZoom,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                RawImage(
                  image: vumbModel.vumbSymbol,
                  width: 48 / VumblerTextures.vumbZoom,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Snappable extends StatefulWidget {
  /// Widget to be snapped
  final Widget child;

  /// Direction and range of snap effect
  /// (Where and how far will particles go)
  final Offset offset;

  /// Duration of whole snap animation
  final Duration duration;

  /// How much can particle be randomized,
  /// For example if [offset] is (100, 100) and [randomDislocationOffset] is (10,10),
  /// Each layer can be moved to maximum between 90 and 110.
  final Offset randomDislocationOffset;

  /// Number of layers of images,
  /// The more of them the better effect but the more heavy it is for CPU
  final int numberOfBuckets;

  /// Quick helper to snap widgets when touched
  /// If true wraps the widget in [GestureDetector] and starts [snap] when tapped
  /// Defaults to false
  final bool snapOnTap;

  /// Function that gets called when snap ends
  final VoidCallback onSnapped;

  const Snappable({
    Key? key,
    required this.child,
    this.offset = const Offset(64, -32),
    this.duration = const Duration(milliseconds: 5000),
    this.randomDislocationOffset = const Offset(64, 32),
    this.numberOfBuckets = 16,
    this.snapOnTap = false,
    required this.onSnapped,
  }) : super(key: key);

  @override
  SnappableState createState() => SnappableState();
}

class SnappableState extends State<Snappable>
    with SingleTickerProviderStateMixin {
  static const double _singleLayerAnimationLength = 0.6;
  static const double _lastLayerAnimationStart =
      1 - _singleLayerAnimationLength;

  bool get isGone => _animationController.isCompleted;
  bool get isInProgress => _animationController.isAnimating;

  /// Main snap effect controller
  late AnimationController _animationController;

  /// Key to get image of a [widget.child]
  final GlobalKey _globalKey = GlobalKey();

  /// Layers of image
  List<Uint8List> _layers = [];

  /// Values from -1 to 1 to dislocate the layers a bit
  late List<double> _randoms;

  /// Size of child widget
  late Size size;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onSnapped();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.snapOnTap ? () => isGone ? reset() : snap() : null,
      child: Stack(
        children: <Widget>[
          if (_layers != []) ..._layers.map(_imageToWidget),
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return _animationController.isDismissed ? child! : Container();
            },
            child: RepaintBoundary(
              key: _globalKey,
              child: widget.child,
            ),
          )
        ],
      ),
    );
  }

  /// I am... INEVITABLE      ~Thanos
  Future<void> snap() async {
    //get image from child
    final fullImage = await _getImageFromWidget();

    //create an image for every bucket
    List<image.Image> images = List<image.Image>.generate(
      widget.numberOfBuckets,
      (i) => image.Image(fullImage.width, fullImage.height),
    );

    //for every line of pixels
    for (int y = 0; y < fullImage.height; y++) {
      //generate weight list of probabilities determining
      //to which bucket should given pixels go
      List<int> weights = List.generate(
        widget.numberOfBuckets,
        (bucket) => _gauss(
          y / fullImage.height,
          bucket / widget.numberOfBuckets,
        ),
      );
      int sumOfWeights = weights.fold(0, (sum, el) => sum + el);

      //for every pixel in a line
      for (int x = 0; x < fullImage.width; x++) {
        //get the pixel from fullImage
        int pixel = fullImage.getPixel(x, y);
        //choose a bucket for a pixel
        int imageIndex = _pickABucket(weights, sumOfWeights);
        //set the pixel from chosen bucket
        images[imageIndex].setPixel(x, y, pixel);
      }
    }

    //* compute allows us to run _encodeImages in separate isolate
    //* as it's too slow to work on the main thread
    _layers = await compute<List<image.Image>, List<Uint8List>>(
        _encodeImages, images);

    //prepare random dislocations and set state
    setState(() {
      _randoms = List.generate(
        widget.numberOfBuckets,
        (i) => (Random().nextDouble() - 0.5) * 2,
      );
    });

    //give a short delay to draw images
    await Future.delayed(const Duration(milliseconds: 100));

    //start the snap!
    _animationController.forward();
  }

  /// I am... IRON MAN   ~Tony Stark
  void reset() {
    setState(() {
      _layers = [];
      _animationController.reset();
    });
  }

  Widget _imageToWidget(Uint8List layer) {
    //get layer's index in the list
    int index = _layers.indexOf(layer);

    //based on index, calculate when this layer should start and end
    double animationStart = (index / _layers.length) * _lastLayerAnimationStart;
    double animationEnd = animationStart + _singleLayerAnimationLength;

    //create interval animation using only part of whole animation
    CurvedAnimation animation = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        animationStart,
        animationEnd,
        curve: Curves.easeOut,
      ),
    );

    Offset randomOffset = widget.randomDislocationOffset.scale(
      _randoms[index],
      _randoms[index],
    );

    Animation<Offset> offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: widget.offset + randomOffset,
    ).animate(animation);

    return AnimatedBuilder(
      animation: _animationController,
      child: Image.memory(layer),
      builder: (context, child) {
        return Transform.translate(
          offset: offsetAnimation.value,
          child: Opacity(
            opacity: cos(animation.value * pi / 2),
            child: child,
          ),
        );
      },
    );
  }

  /// Returns index of a randomly chosen bucket
  int _pickABucket(List<int> weights, int sumOfWeights) {
    int rnd = Random().nextInt(sumOfWeights);
    int chosenImage = 0;
    for (int i = 0; i < widget.numberOfBuckets; i++) {
      if (rnd < weights[i]) {
        chosenImage = i;
        break;
      }
      rnd -= weights[i];
    }
    return chosenImage;
  }

  /// Gets an Image from a [child] and caches [size] for later us
  Future<image.Image> _getImageFromWidget() async {
    RenderRepaintBoundary? boundary =
        _globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    //cache image for later
    size = boundary.size;
    var img = await boundary.toImage();
    ByteData? byteData = await img.toByteData(format: ImageByteFormat.png);
    var pngBytes = byteData?.buffer.asUint8List();

    return image.decodeImage(pngBytes!)!;
  }

  int _gauss(double center, double value) =>
      (1000 * exp(-(pow((value - center), 2) / 0.14))).round();
}

/// This is slow! Run it in separate isolate
List<Uint8List> _encodeImages(List<image.Image> images) {
  return images.map((img) => Uint8List.fromList(image.encodePng(img))).toList();
}
