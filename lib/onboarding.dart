import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/Colors.dart';
import 'package:todo/homepage.dart';
import 'package:velocity_x/velocity_x.dart';

class OnBoarding extends StatefulWidget {
  OnBoarding({
    Key? key,
  }) : super(key: key);

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //insert image from assets images folder
              Image.asset("assets/images/Onboarding.png", height: 400)
                  .pSymmetric(h: 20),

              Text(
                'Your Name',
                style: GoogleFonts.roboto(
                  color: AppColor.primaryColor,
                ),
              ).text.xl3.bold.make().px24(),
              SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColor.primaryColor, width: 2),
                ),
                child: TextField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  cursorHeight: 20,
                  autofocus: true,
                  cursorColor: AppColor.primaryColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your first name',
                    hintStyle: GoogleFonts.roboto(
                      color: AppColor.greyColor,
                      fontSize: 18,
                    ),
                  ),
                ).px12(),
              ).p12(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setString('name', _nameController.text);
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                    name: _nameController.text,
                                  )));
                    },
                    child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: AppColor.primaryColor),
                        child: Center(
                            child: Text('Get Started')
                                .text
                                .xl2
                                .semiBold
                                .white
                                .make()
                                .p12())),
                  ),
                ],
              ),
            ],
          ).px12(),
        ),
      ),
    );
  }
}
