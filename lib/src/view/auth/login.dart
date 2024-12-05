import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:DigiRestro/commons/controls/custom_button.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/commons/controls/custom_textfield.dart';
import 'package:DigiRestro/src/repository/login/login_bloc.dart';
import 'package:DigiRestro/src/view/auth/signup.dart';
import 'package:DigiRestro/utils/app_color.dart';
import 'package:DigiRestro/utils/extension.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    context.read<LoginBloc>().add(OnCheckLogin(context: context));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          letterSpacing: 3,
          text: 'Login',
          size: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Welcome to\nDigiRestro',
            letterSpacing: 1.1,
            fontWeight: FontWeight.w600,
            size: 26,
            color: AppColor.black,
          ),
          CustomTextField(
            controller: emailController,
            hintText: 'Enter your email',
            borderSide: BorderSide(color: AppColor.black),
          ),
          const Gap(18),
          CustomTextField(
            controller: passController,
            hintText: 'Enter your password',
            obscureText: true,
            borderSide: BorderSide(
              color: AppColor.black,
            ),
          ),
          const Gap(18),
          const Gap(10),
          CustomButton(
            radius: 18,
            text: 'Login',
            textColor: AppColor.white,
            onTap: () {
              context.read<LoginBloc>().add(OnEmailLogin(context,
                  email: emailController.text.trim(),
                  password: passController.text.trim()));
            },
          ),
          const Gap(14),
          Center(child: CustomText(text: 'or continue with')),
          Center(
            child: GestureDetector(
              onTap: () {
                context.read<LoginBloc>().add(OnGoogleLogin(context: context));
              },
              child: SvgPicture.asset(
                'lib/commons/assets/google.svg',
                height: 80,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomText(
                letterSpacing: 2,
                text: 'Don\'t have an account? ',
                fontWeight: FontWeight.w600,
                color: AppColor.greyText,
              ),
              CustomText(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (builder) {
                    return SignUp();
                  }));
                },
                letterSpacing: 1.3,
                text: 'Signup',
                color: Colors.green.shade300,
                fontWeight: FontWeight.w700,
              )
            ],
          )
        ],
      ).addMargin(const EdgeInsets.only(left: 20, right: 20)),
    );
  }
}
