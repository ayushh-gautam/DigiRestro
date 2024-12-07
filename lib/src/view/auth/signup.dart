import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:DigiRestro/commons/controls/custom_text.dart';
import 'package:DigiRestro/utils/extension.dart';

import '../../../commons/controls/custom_button.dart';
import '../../../commons/controls/custom_textfield.dart';
import '../../../utils/app_color.dart';
import '../../repository/login/login_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController confirmPassController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    emailController = TextEditingController();
    passController = TextEditingController();
    confirmPassController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: CustomText(text: 'SignUp'),
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
              size: 26,
              color: AppColor.black,
            ),
            const Gap(18),
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
            const Gap(18),
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
            const Gap(18),
            CustomTextField(
              controller: confirmPassController,
              hintText: 'confirm your password',
              obscureText: true,
              borderSide: BorderSide(
                color: AppColor.black,
              ),
              validator: (value) {
                if (value?.trim().isEmpty ?? false) {
                  return "Please confirm your Password!";
                } else {
                  return null;
                }
              },
            ),
            const Gap(18),
            const Gap(10),
            CustomButton(
              radius: 18,
              widget:
                  BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
                if (state is LoginLoading) {
                  return const CircularProgressIndicator(
                    color: Colors.white,
                  );
                } else {
                  return CustomText(
                    text: 'SignUp',
                    color: AppColor.white,
                    fontWeight: FontWeight.w700,
                    size: 20,
                  );
                }
              }),
              textColor: AppColor.white,
              onTap: () {
                if (_formKey.currentState?.validate() ?? false) {
                  if (passController.text.trim() ==
                      confirmPassController.text.trim()) {
                    context.read<LoginBloc>().add(OnEmailSignUp(
                        context: context,
                        email: emailController.text.trim(),
                        password: confirmPassController.text.trim()));
                  } else {
                    Fluttertoast.showToast(
                        msg: "Password and confirm password doesn't Matched!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        backgroundColor: Colors.redAccent,
                        fontSize: 18);
                  }
                }
              },
            ),
            const Gap(14),
            // Center(child: CustomText(text: 'or signup with')),
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
                  text: 'Already have an account? ',
                  fontWeight: FontWeight.w600,
                  color: AppColor.greyText,
                ),
                CustomText(
                  onTap: () {
                    // Navigator.of(context)
                    //     .push(MaterialPageRoute(builder: (builder) {
                    //   return LoginPage();
                    // }));
                    Navigator.pop(context);
                  },
                  letterSpacing: 1.3,
                  text: 'Login',
                  color: Colors.green.shade300,
                  fontWeight: FontWeight.w700,
                )
              ],
            )
          ],
        ).addMargin(const EdgeInsets.only(left: 20, right: 20)),
      ),
    );
  }
}
