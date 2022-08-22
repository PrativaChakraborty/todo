import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/Colors.dart';
import 'package:velocity_x/velocity_x.dart';
import 'OnboardingScreen2.dart';

class OnboardingScreen1 extends StatelessWidget {
  const OnboardingScreen1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: context.screenHeight * 0.2,
          ),
          Image.asset('assets/images/OnboardingScreen1.png'),
          SizedBox(
            height: context.screenHeight * 0.1,
          ),
          Text(
            "Organize your day with ease",
            style: GoogleFonts.roboto(),
          ).text.gray600.xl2.bold.extraBold.make(),
          SizedBox(
            height: context.screenHeight * 0.1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OnboardingScreen2(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_forward,
                  color: AppColor.primaryColor,
                  size: 30,
                ),
                color: Colors.blue,
              ),
            ],
          )
        ],
      )),
    );
  }
}
