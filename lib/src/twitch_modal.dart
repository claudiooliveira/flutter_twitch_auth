import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_twitch/flutter_twitch.dart';
import 'package:flutter_twitch_auth/src/twitch_auth_controller.dart';
import 'package:webview_flutter/webview_flutter.dart';

enum ModalResponseType { code, user }

class TwitchModalContent extends StatefulWidget {
  final ModalResponseType responseType;
  const TwitchModalContent(this.responseType, {Key? key}) : super(key: key);

  @override
  _TwitchModalContentState createState() => _TwitchModalContentState();
}

class _TwitchModalContentState extends State<TwitchModalContent> {
  final CookieManager cookieManager = CookieManager();
  final FlutterTwitchAuth twitchAuthController = FlutterTwitchAuth.instance;
  String url = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    url = "https://id.twitch.tv/oauth2/authorize"
        "?response_type=${twitchAuthController.responseType}"
        "&client_id=${twitchAuthController.TWITCH_CLIENT_ID}"
        "&redirect_uri=${twitchAuthController.TWITCH_REDIRECT_URI}"
        "&scope=${twitchAuthController.scope}";
    cookieManager.clearCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        navigationDelegate: (NavigationRequest request) async {
          try {
            if (request.url
                .contains(twitchAuthController.TWITCH_REDIRECT_URI)) {
              final String? authCode =
                  Uri.parse(request.url).queryParameters['code'];

              /// Pop with the auth code
              /// User will be retrieved using this on the app side
              if (authCode != null) {
                switch (widget.responseType) {
                  case ModalResponseType.user:
                    final users =
                        await FlutterTwitch.users.getUsersByCode(authCode);
                    Navigator.of(context).pop(users.data.first);

                    break;
                  case ModalResponseType.code:
                    Navigator.of(context).pop(authCode);
                    break;
                }
              }
            }

            // Continue navigation for any other url.
            return NavigationDecision.navigate;
          } catch (e) {
            // Let the caller know that the flow is completed and
            Navigator.of(context).pop();
            // Prevent the navigation
            return NavigationDecision.prevent;
          }
        },
      ),
    );
  }
}
