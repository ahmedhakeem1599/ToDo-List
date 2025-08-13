import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      globalBackgroundColor: Colors.white,
      showNextButton: true,
      showDoneButton: true,
      showSkipButton: true,
      done: const Text("Done"),
      onDone: () { Get.offAllNamed("/login"); },
      skip: const Text("Skip"),
      onSkip: () { Get.offAllNamed("/login"); },
      next: const Icon(Icons.arrow_forward),
      pages: [

        PageViewModel(
          image: Image.asset('assets/5155461_2715086.jpg',height: 500,),
          title: "ToDo App",
          body :  "Welcome to Your Daily ToDo!",
          decoration: const PageDecoration(
            imagePadding: EdgeInsets.only(top: 100)
          )
        ),

        PageViewModel(
            image: SvgPicture.asset('assets/intro2.svg',height: 500,),
            title: "ToDo App",
            body :  "Success begins with a small step every day. Use your app to organize your tasks and achieve your goals with ease. Keep progressing!",
            decoration: const PageDecoration(
                imagePadding: EdgeInsets.only(top: 100)
            )
        ),

        PageViewModel(
            image: Image.asset('assets/intro.jpg',height: 500,),
            title: "ToDo App",
            body :  "Provides initial motivation and invites the user to get started",
            decoration: const PageDecoration(
                imagePadding: EdgeInsets.only(top: 100)
            )
        )

      ],


    );
  }
}
