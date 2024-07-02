import 'package:apphud/apphud.dart';
import 'package:apphud/models/apphud_models/apphud_composite_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:vumbler_cards/game_frames/game_vumb_frame.dart';
import 'package:vumbler_cards/game_frames/shop_vumb_frame.dart';
import 'package:vumbler_cards/game_frames/system_vumb_frame.dart';
import 'package:vumbler_cards/game_utils/vumbler_coins.dart';
import 'package:vumbler_cards/game_utils/vumbler_music.dart';
import 'package:vumbler_cards/game_utils/vumbler_storage.dart';
import 'package:vumbler_cards/game_utils/vumbler_textures.dart';

class MainVumbFrame extends StatefulWidget {
  const MainVumbFrame({super.key});

  @override
  State<MainVumbFrame> createState() => _MainVumbFrameState();
}

class _MainVumbFrameState extends State<MainVumbFrame> {
  vumb_settings() {
    RxBool vumbRest = false.obs;
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
                height: (377 + 50) / VumblerTextures.vumbZoom,
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
                              'Settings'.toUpperCase(),
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
                          'cassets/frames/medium_dial.png',
                          height: 377 / VumblerTextures.vumbZoom,
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
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Get.to(() => SystemVumbFrame(
                                        vumbTy: 0,
                                      ));
                                },
                                child: Text(
                                  'Privacy Policy'.toUpperCase(),
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
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Get.to(() => SystemVumbFrame(
                                        vumbTy: 1,
                                      ));
                                },
                                child: Text(
                                  'Terms of Use'.toUpperCase(),
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
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  Get.to(() => SystemVumbFrame(
                                        vumbTy: 2,
                                      ));
                                },
                                child: Text(
                                  'Support'.toUpperCase(),
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
                                behavior: HitTestBehavior.opaque,
                                onTap: () async {
                                  if (!vumbRest.value) {
                                    vumbRest.value = true;
                                    final ApphudComposite vumbrestPuCards =
                                        await Apphud.restorePurchases();

                                    bool vumbfailPu = true;

                                    if (vumbrestPuCards.purchases.isNotEmpty) {
                                      for (final pu
                                          in vumbrestPuCards.purchases) {
                                        if (pu.productId == 'ice_card') {
                                          vumbfailPu = false;
                                          VumblerStorage.vumblerStorage!
                                              .setBool('ice', true);
                                        }
                                      }

                                      Get.showSnackbar(
                                        GetSnackBar(
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.black,
                                          messageText: Center(
                                            child: Text(
                                              'Purchases restored',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    if (vumbfailPu) {
                                      Get.showSnackbar(
                                        GetSnackBar(
                                          duration: Duration(seconds: 2),
                                          backgroundColor: Colors.black,
                                          messageText: Center(
                                            child: Text(
                                              'Purchase is not found',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      );
                                    }

                                    vumbRest.value = false;
                                  }
                                },
                                child: Obx(
                                  () => vumbRest.value
                                      ? CupertinoActivityIndicator(
                                          color: Colors.white,
                                        )
                                      : Text(
                                          'Restore Purchases'.toUpperCase(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize:
                                                  20 / VumblerTextures.vumbZoom,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 2 / VumblerTextures.vumbZoom,
                      child: GestureDetector(
                        onTap: Get.back,
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
    );
  }

  vumb_records() {
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
                height: (377 + 50) / VumblerTextures.vumbZoom,
                margin: const EdgeInsets.symmetric(horizontal: 14),
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
                              'Records'.toUpperCase(),
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
                          'cassets/frames/medium_dial.png',
                          height: 377 / VumblerTextures.vumbZoom,
                        ),
                        SizedBox(
                          width: 172 / VumblerTextures.vumbZoom,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'cassets/buttons/beginner_rec.png',
                                    height: 49 / VumblerTextures.vumbZoom,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      (VumblerStorage.vumblerStorage!
                                                  .getInt('vumbRec_1') ??
                                              0)
                                          .toString(),
                                      style: TextStyle(
                                          fontSize:
                                              20 / VumblerTextures.vumbZoom,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 33 / VumblerTextures.vumbZoom,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'cassets/buttons/intermediate_rec.png',
                                    height: 49 / VumblerTextures.vumbZoom,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: Text(
                                      (VumblerStorage.vumblerStorage!
                                                  .getInt('vumbRec_2') ??
                                              0)
                                          .toString(),
                                      style: TextStyle(
                                          fontSize:
                                              20 / VumblerTextures.vumbZoom,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 33 / VumblerTextures.vumbZoom,
                              ),
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.asset(
                                    'cassets/buttons/professional_rec.png',
                                    height: 49 / VumblerTextures.vumbZoom,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 20 / VumblerTextures.vumbZoom),
                                    child: Text(
                                      (VumblerStorage.vumblerStorage!
                                                  .getInt('vumbRec_3') ??
                                              0)
                                          .toString(),
                                      style: TextStyle(
                                          fontSize:
                                              20 / VumblerTextures.vumbZoom,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 2 / VumblerTextures.vumbZoom,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: Get.back,
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
    );
  }

  vumb_modess() {
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
                height: (377 + 50) / VumblerTextures.vumbZoom,
                margin: const EdgeInsets.symmetric(horizontal: 14),
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
                              'plAy'.toUpperCase(),
                              style: TextStyle(
                                  fontSize: 16,
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
                          'cassets/frames/medium_dial.png',
                          height: 377 / VumblerTextures.vumbZoom,
                        ),
                        SizedBox(
                          width: 172 / VumblerTextures.vumbZoom,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => GameVumbFrame(
                                        vumbType: '1',
                                        vumbMaxLoses: 5,
                                      ));
                                },
                                child: Image.asset(
                                  'cassets/buttons/beginner.png',
                                  height: 60 / VumblerTextures.vumbZoom,
                                ),
                              ),
                              SizedBox(
                                height: 29 / VumblerTextures.vumbZoom,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => GameVumbFrame(
                                        vumbType: '2',
                                        vumbMaxLoses: 4,
                                      ));
                                },
                                child: Image.asset(
                                  'cassets/buttons/intermediate.png',
                                  height: 60 / VumblerTextures.vumbZoom,
                                ),
                              ),
                              SizedBox(
                                height: 29 / VumblerTextures.vumbZoom,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Get.to(() => GameVumbFrame(
                                        vumbType: '3',
                                        vumbMaxLoses: 3,
                                      ));
                                },
                                child: Image.asset(
                                  'cassets/buttons/professional.png',
                                  height: 60 / VumblerTextures.vumbZoom,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 2 / VumblerTextures.vumbZoom,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: Get.back,
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
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if ((VumblerStorage.vumblerStorage!.getBool('vumbMu') ?? true) &&
          !VumblerMusic.vumblerPl) {
        VumblerMusic.goVumbMu('cassets/back.mp3');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('cassets/frames/main.png'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: SizedBox(
                    width: 241 / VumblerTextures.vumbZoom,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'cassets/buttons/coins.png',
                          height: 81 / VumblerTextures.vumbZoom,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: 20 / VumblerTextures.vumbZoom),
                          // child: ShaderMask(
                          //   blendMode: BlendMode.srcATop,
                          //   shaderCallback: (bounds) {
                          //     final vumbscaleX = bounds.width /
                          //         VumblerTextures.vumblerShader.width;
                          //     final vumbscaleY = bounds.height /
                          //         VumblerTextures.vumblerShader.height;
                          //     final vumbscale = max(vumbscaleX, vumbscaleY);
                          //     final vumbscaledImageWidth =
                          //         VumblerTextures.vumblerShader.width * vumbscale;
                          //     final vumbsacledImageHeight =
                          //         VumblerTextures.vumblerShader.height *
                          //             vumbscale;
                          //     final offset = Offset(
                          //       (vumbscaledImageWidth - bounds.width) / 2,
                          //       (vumbsacledImageHeight - bounds.height) / 2,
                          //     );
                          //     final vumbmatrix = Matrix4.identity()
                          //       // Scale image
                          //       //..scale(vumbscale, vumbscale)
                          //       ..leftTranslate(
                          //         -offset.dx,
                          //         -offset.dy,
                          //       );
                          //     return ImageShader(
                          //       VumblerTextures.vumblerShader,
                          //       TileMode.clamp,
                          //       TileMode.clamp,
                          //       vumbmatrix.storage,
                          //     );
                          //   },
                          //   child: Text(
                          //     '1000',
                          //     style: TextStyle(
                          //       fontSize: 25,
                          //       fontWeight: FontWeight.w500,
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'cassets/buttons/money.png',
                                height: 18 / VumblerTextures.vumbZoom,
                              ),
                              SizedBox(
                                width: 8 / VumblerTextures.vumbZoom,
                              ),
                              Obx(
                                () => Text(
                                  VumblerCoins.vumblerCoins.value.toString(),
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 8 / VumblerTextures.vumbZoom,
                              ),
                              Opacity(
                                opacity: 0,
                                child: Image.asset(
                                  'cassets/buttons/money.png',
                                  height: 18 / VumblerTextures.vumbZoom,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: vumb_modess,
                      child: Image.asset(
                        'cassets/buttons/play.png',
                        height: 102 / VumblerTextures.vumbZoom,
                      ),
                    ),
                    SizedBox(
                      height: 32 / VumblerTextures.vumbZoom,
                    ),
                    GestureDetector(
                      onTap: vumb_records,
                      child: Image.asset(
                        'cassets/buttons/records.png',
                        height: 60 / VumblerTextures.vumbZoom,
                      ),
                    ),
                    SizedBox(
                      height: 15 / VumblerTextures.vumbZoom,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => ShopVumbFrame());
                      },
                      child: Image.asset(
                        'cassets/buttons/shop.png',
                        height: 60 / VumblerTextures.vumbZoom,
                      ),
                    ),
                    SizedBox(
                      height: 15 / VumblerTextures.vumbZoom,
                    ),
                    GestureDetector(
                      onTap: vumb_settings,
                      child: Image.asset(
                        'cassets/buttons/settings.png',
                        height: 60 / VumblerTextures.vumbZoom,
                      ),
                    ),
                    SizedBox(
                      height: 36 / VumblerTextures.vumbZoom,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
