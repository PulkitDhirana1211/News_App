import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:news_app/screens/homescreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 1;
    final width = MediaQuery.of(context).size.width * 1;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: height * 0.5,
            child: Lottie.asset(
              "assets/json/news.json",
              controller: _controller,
              onLoaded: (compose) {
                _controller
                  ..duration = compose.duration
                  ..forward().then((value) {
                    Future.delayed(const Duration(milliseconds: 1000), () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()));
                    });
                  });
              },
            ),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Text(
            "Top Headlines",
            style: GoogleFonts.openSans(
                letterSpacing: .6, color: Colors.grey.shade700),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          const SpinKitChasingDots(
            color: Colors.blue,
            size: 40,
          )
        ],
      ),
    );
  }
}
