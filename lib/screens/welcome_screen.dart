import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/components/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  late AnimationController myController;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    myController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,);
    myController.forward();
    animation = ColorTween(begin: Colors.blueGrey,end: Colors.white).animate(myController);
    myController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    child: Image.asset('images/logo.png'),
                    height: 60,
                  ),
                ),
                SizedBox(
                    width: 250.0,
                    child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'Flash Chat',
                            textStyle: const TextStyle(
                              fontSize: 45.0,
                              fontWeight: FontWeight.w900,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                        totalRepeatCount: 3,
                        pause: const Duration(seconds: 2),
                      ),
                    ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
                color: Colors.lightBlueAccent,
                text: 'Log In',
                onPressed: ()=>Navigator.pushNamed(context, LoginScreen.id)),
            RoundedButton(
                color: Colors.blueAccent,
                text: 'Register',
                onPressed: ()=>Navigator.pushNamed(context, RegistrationScreen.id)),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16.0),
            //   child: Material(
            //     elevation: 5.0,
            //     color: Colors.lightBlueAccent,
            //     borderRadius: BorderRadius.circular(30.0),
            //     child: MaterialButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, LoginScreen.id);
            //       },
            //       minWidth: 200.0,
            //       height: 42.0,
            //       child: const Text(
            //         'Log In',
            //       ),
            //     ),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 16.0),
            //   child: Material(
            //     color: Colors.blueAccent,
            //     borderRadius: BorderRadius.circular(30.0),
            //     elevation: 5.0,
            //     child: MaterialButton(
            //       onPressed: () {
            //         Navigator.pushNamed(context, RegistrationScreen.id);
            //       },
            //       minWidth: 200.0,
            //       height: 42.0,
            //       child: const Text(
            //         'Register',
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}