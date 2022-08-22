import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo/onboarding.dart';
import 'package:velocity_x/velocity_x.dart';
import 'Colors.dart';
import 'OnboardingScreen2.dart';

class OnboardingScreen2 extends StatelessWidget {
  const OnboardingScreen2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          SizedBox(
            height: context.screenHeight * 0.2,
          ),
          Image.asset('assets/images/OnboardingScreen2.png'),
          SizedBox(
            height: context.screenHeight * 0.1,
          ),
          Text(
            "Achieve your daily goals",
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
                      builder: (context) => OnBoarding(),
                    ),
                  );
                },
                icon: Icon(
                  Icons.arrow_forward,
                  color: AppColor.primaryColor,
                  size: 30,
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
