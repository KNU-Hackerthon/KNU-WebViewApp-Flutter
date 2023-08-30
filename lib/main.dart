import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  InAppWebViewController? webView;

  void loadPosition() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String geolocationJSString = '''
       navigator.geolocation.getCurrentPosition = function(success, error, options) {
         success({"coords" : {"latitude": ${position.latitude}, "longitude": ${position.longitude}, "altitude": ${position.altitude}, "accuracy": ${position.accuracy}, "heading" :${position.heading} , "speed": ${position.speed}}});
       };
     ''';

    webView?.evaluateJavascript(source: geolocationJSString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest:
          URLRequest(url: Uri.parse('https://knuhackerton-web.vercel.app')),
          onWebViewCreated:(InAppWebViewController controller){
            webView=controller;
            loadPosition();
          },
          androidOnPermissionRequest:
              (InAppWebViewController controller, String origin,
              List<String> resources) async {
            return PermissionRequestResponse(
                resources: resources,
                action:
                PermissionRequestResponseAction.GRANT);
          },
        ),
      ),
    );
  }
}
