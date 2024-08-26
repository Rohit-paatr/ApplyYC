import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:ApplyYC/variables.dart' as variables;

final String stripeUrl =
    "https://create-checkout-session-mad2rp6oyq-uc.a.run.app/create-checkout-session?userID=";
// void _openStripeInWebView(BuildContext context) {
//   final userId = variables.userData!['email'];
//   final url = '$stripeUrl${Uri.encodeComponent(userId)}';

//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => webview
//        WebView(
//         initialUrl: url,
//         javascriptMode: JavascriptMode.unrestricted,
//       ),
//     ),
//   );
// }

var controller = WebViewController()
  ..setJavaScriptMode(JavaScriptMode.unrestricted)
  ..setNavigationDelegate(
    NavigationDelegate(
      onProgress: (int progress) {
        // Update loading bar.
      },
      onPageStarted: (String url) {},
      onPageFinished: (String url) {},
      onHttpError: (HttpResponseError error) {},
      onWebResourceError: (WebResourceError error) {},
      onNavigationRequest: (NavigationRequest request) {
        if (request.url.startsWith('https://www.youtube.com/')) {
          return NavigationDecision.prevent;
        }
        return NavigationDecision.navigate;
      },
    ),
  )
  ..loadRequest(Uri.parse(stripeUrl));
