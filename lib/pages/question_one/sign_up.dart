import 'package:bionic/common/button_primary.dart';
import 'package:bionic/common/snackbar_global.dart';
import 'package:bionic/common/title_heading.dart';
import 'package:bionic/constants/app_assets.dart';
import 'package:bionic/constants/app_colors.dart';
import 'package:bionic/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool? isChecked = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        flexibleSpace: SvgPicture.asset(
          AppAssets.waveOrange,
          fit: BoxFit.cover,
        ),
        toolbarHeight: MediaQuery.sizeOf(context).height * 0.16,
        scrolledUnderElevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
          12,
          0,
          12,
          22,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const TitleHeading(
              title: AppConstants.signUp,
            ),
            const SizedBox(
              height: 20,
            ),
            const TextInputField(
              hintText: AppConstants.name,
            ),
            const TextInputField(
              hintText: AppConstants.email,
            ),
            const TextInputField(
              hintText: AppConstants.password,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value;
                    });
                  },
                ),
                const Text(
                  AppConstants.remember,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.13,
                ),
                TextButton(
                  onPressed: () {
                    SnackbarGlobal.show("Forgot Password");
                  },
                  child: const Text(
                    AppConstants.forgotPassword,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepPurpleColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            ButtonPrimary(
              btnTitle: AppConstants.signUp,
              onPress: () {
                SnackbarGlobal.show("Sign up");
              },
            ),
            const Spacer(),
            const Text(
              AppConstants.haveAccount,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            TextButton(
              onPressed: () {
                SnackbarGlobal.show("Sign in");
              },
              child: const Text(
                AppConstants.signIn,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepPurpleColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextInputField extends StatelessWidget {
  final String hintText;

  const TextInputField({
    super.key,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
