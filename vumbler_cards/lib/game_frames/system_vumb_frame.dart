import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vumbler_cards/game_utils/vumbler_textures.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SystemVumbFrame extends StatefulWidget {
  final num vumbTy;
  const SystemVumbFrame({super.key, required this.vumbTy});

  @override
  State<SystemVumbFrame> createState() => _SystemVumbFrameState();
}

class _SystemVumbFrameState extends State<SystemVumbFrame> {
  late WebViewController vaultCon;

  @override
  void initState() {
    vaultCon = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(
        // pp
        widget.vumbTy == 0
            ? 'https://docs.google.com/document/d/1iePnxJLPzpZmMSBTFG6DixbEl-eWJJK-QAY8frGHlNw/edit?usp=sharing'
            // tou
            : widget.vumbTy == 1
                ? 'https://docs.google.com/document/d/1Q4SavUINEFU33Y6ZUDzUfkg_DnLIYKIhrgXKux7MULQ/edit?usp=sharing'
                : 'https://sites.google.com/view/rana-asim/support-form',
      ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('cassets/frames/shop.png'), fit: BoxFit.fill),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  height: 24 / VumblerTextures.vumbZoom,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: Get.back,
                      child: Image.asset(
                        'cassets/buttons/back_circle.png',
                        height: 40 / VumblerTextures.vumbZoom,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        (widget.vumbTy == 0
                                ? 'Privacy POlicy'
                                : widget.vumbTy == 1
                                    ? 'Terms oF Use'
                                    : 'SuppoRt')
                            .toUpperCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 40 / VumblerTextures.vumbZoom,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: 0,
                      child: Image.asset(
                        'cassets/buttons/back_circle.png',
                        height: 40 / VumblerTextures.vumbZoom,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 55 / VumblerTextures.vumbZoom,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30 / VumblerTextures.vumbZoom),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: WebViewWidget(
                        controller: vaultCon,
                      ),
                    ),
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
