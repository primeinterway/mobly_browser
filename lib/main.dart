import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mobly_browser/constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mobly Browser',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: MoblyWV(),
    );
  }
}

class MoblyWV extends StatefulWidget {
  const MoblyWV({Key? key}) : super(key: key);

  @override
  _MoblyWVState createState() => _MoblyWVState();
}

class _MoblyWVState extends State<MoblyWV> {

  InAppWebViewController? _controller;

  bool loading = true;
  bool home = true;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: InAppWebView(
            initialUrlRequest:
                URLRequest(url: Uri.parse(siteUrl)),
            gestureRecognizers: Set()
              ..add(
                Factory<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer()),
              ),
            initialOptions: InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  useOnDownloadStart: true,
                  javaScriptEnabled: true,
                  javaScriptCanOpenWindowsAutomatically: true),
              android: AndroidInAppWebViewOptions(
                allowContentAccess: true,
                builtInZoomControls: true,
                thirdPartyCookiesEnabled: true,
                useHybridComposition: true,
                allowFileAccess: true,
                supportMultipleWindows: true,
                domStorageEnabled: true,
                databaseEnabled: true,
              ),
            ),
            onLoadStart: (controller, uri) {
              _controller = controller;
              setState(() {
                loading = true;
              });
            },
            onLoadStop: (controller, uri) {
              setState(() {
                if (uri!.path == "/$storeName") {
                  home = true;
                } else {
                  home = false;
                }
                loading = false;
              });
            },
            onProgressChanged: (controller, progress) {
              if (progress == 100) {
                if (loading) {
                  setState(() {
                    loading = false;
                  });
                }
              } else {
                if (!loading) {
                  setState(() {
                    loading = true;
                  });
                }
              }
            },
          )),
      loading
          ? Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: SizedBox(
                      child: LinearProgressIndicator(),
                      height: 50.0,
                      width: 50.0,
                    ),
                  ),
                )
              ],
            )
          : Stack(),
      !home
          ? Column(
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.all(30),
                  child: ClipOval(
                    child: Material(
                      color: Colors.deepOrange.withOpacity(0.8), // Button color
                      child: InkWell(
                        splashColor: Colors.deepOrangeAccent, // Splash color
                        onTap: () async {
                          if(_controller != null) {
                            _controller!.goBack();
                          }
                        },
                        child: SizedBox(
                            width: 46,
                            height: 46,
                            child: Icon(
                              Icons.arrow_back_ios_sharp,
                              color: Colors.white.withOpacity(0.8),
                            )),
                      ),
                    ),
                  ),
                )
              ],
            )
          : Container()
    ]);
  }
}
