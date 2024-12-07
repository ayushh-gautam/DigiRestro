import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late TextEditingController emailController;
  late TextEditingController passController;
  @override
  void initState() {
    // context.read<LoginBloc>().add(OnCheckLogin(context: context));
    emailController = TextEditingController();
    passController = TextEditingController();
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(
          letterSpacing: 3.h,
          text: 'Login',
          size: 28,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Welcome to\nDigiRestro',
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
              size: 26.h,
              color: AppColor.black,
            ),
            Gap(30.h),
            CustomTextField(
              controller: emailController,
              hintText: 'Enter your email',
              borderSide: BorderSide(color: AppColor.black),
              validator: (value) {
                if (value?.trim().isEmpty ?? false) {
                  return "Please enter your Email!";
                } else {
                  return null;
                }
              },
            ),
            Gap(18.h),
            CustomTextField(
              controller: passController,
              hintText: 'Enter your password',
              obscureText: true,
              borderSide: BorderSide(
                color: AppColor.black,
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? false) {
                  return "Please enter your Password!";
                } else {
                  return null;
                }
              },
            ),
            Gap(18.h),
            Gap(10.h),
            CustomButton(
              radius: 18.h,
              widget:
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                if (state is LoginLoading) {
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                } else {
                  return CustomText(
                    text: 'Login',
                    color: AppColor.white,
                    fontWeight: FontWeight.w700,
                    size: 20,
                  );
                }
              }),
              textColor: AppColor.white,
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  context.read<LoginBloc>().add(OnEmailLogin(context,
                      email: emailController.text.trim(),
                      password: passController.text.trim()));
                }
              },
            ),
            Gap(14.h),
            // Center(child: CustomText(text: 'or continue with')),
            // Center(
            //   child: GestureDetector(
            //     onTap: () {
            //       context.read<LoginBloc>().add(OnGoogleLogin(context: context));
            //     },
            //     child: SvgPicture.asset(
            //       'lib/commons/assets/google.svg',
            //       height: 80,
            //     ),
            //   ),
            // ),
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
        ).addMargin(EdgeInsets.only(left: 20.h, right: 20.h)),
      ),
    );
  }
}
