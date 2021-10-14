import 'package:flutter/material.dart';
import 'package:flutter_twitch/flutter_twitch.dart';
import 'package:flutter_twitch_auth/flutter_twitch_auth.dart';

void main() {
  FlutterTwitchAuth.initialize(
    twitchClientId: "<YOUR_CLIENT_ID>",
    twitchClientSecret: "<YOUR_CLIENT_SECRET>",
    twitchRedirectUri: "<YOUR_REDIRECT_URI>",
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Twitch Auth Example',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user;

  void _handleTwitchSignIn() async {
    user = await FlutterTwitchAuth.authToUser(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Twitch Auth Modal"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 240,
              child: user == null ? twitchButton() : TwitchUser(user!),
            ),
          ],
        ),
      ),
    );
  }

  Widget twitchButton() {
    return ElevatedButton(
      onPressed: () => _handleTwitchSignIn(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/twitch.png',
            width: 26,
            height: 26,
          ),
          const Expanded(
            child: Text(
              "Sign in with Twitch",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          const Color(0xff9146ff),
        ),
        elevation: MaterialStateProperty.all<double>(3),
      ),
    );
  }
}

class TwitchUser extends StatefulWidget {
  final User user;
  const TwitchUser(
    this.user, {
    Key? key,
  }) : super(key: key);

  @override
  _TwitchUserState createState() => _TwitchUserState();
}

class _TwitchUserState extends State<TwitchUser> {
  late User user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  color: Colors.grey.shade300,
                  padding: const EdgeInsets.all(6),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      user.profileImageUrl!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Text(
          "Hello, ${user.displayName}!",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        )
      ],
    );
  }
}
