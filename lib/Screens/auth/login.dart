import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healwiz/Screens/auth/sign_up.dart';

import '../../themes/theme.dart';
import '../home/home.dart';

class SignInScreen extends StatefulWidget {
  SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signInWithEmailAndPassword() async {
    try {
      print(
          "Attempting to sign in with email: ${emailC.text.trim()}"); // Debug log
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: emailC.text.trim(),
        password: passwordC.text.trim(),
      );
      final User? user = userCredential.user;
      print("User signed in: ${user!.email}"); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${user.email} signed in'),
        ),
      );
    } catch (e) {
      print("Failed to sign in: $e"); // Debug log
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in with email and password: $e'),
        ),
      );
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    // Retrieve the size of the screen
    var screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
      backgroundColor: AppColor.kWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(
            width: screenWidth * 0.9, // Adjust width relative to screen size
            child: Column(
              children: [
                Text(
                  'Hi, Welcome Back! 👋',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: screenWidth * 0.06, // Responsive font size
                    fontWeight: FontWeight.w600,
                  ).copyWith(
                      color: AppColor.kGrayscaleDark100,
                      fontSize: screenWidth * 0.06),
                ),
                SizedBox(height: screenHeight * 0.01),
                Text(
                  'We are happy to see you. Sign In to your account',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.plusJakartaSans(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w500,
                          color: AppColor.kWhite)
                      .copyWith(
                          color: AppColor.kGrayscale40,
                          fontSize: screenWidth * 0.04),
                ),
                SizedBox(height: screenHeight * 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Email',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: AppColor.kGrayscaleDark100,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    PrimaryTextFormField(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'abc@gmail.com',
                      controller: emailC,
                      width: screenWidth * 0.9, // Adjust width
                      height: screenHeight * 0.07, // Adjust height
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: AppColor.kGrayscaleDark100,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    PasswordTextField(
                      borderRadius: BorderRadius.circular(24),
                      hintText: 'Password',
                      controller: passwordC,
                      width: screenWidth * 0.9,
                      height: screenHeight * 0.07,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PrimaryTextButton(
                      onPressed: () {},
                      title: 'Forgot Password?',
                      textStyle: TextStyle(fontSize: screenWidth * 0.04),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.04),
                Column(
                  children: [
                    PrimaryButton(
                      elevation: 0,
                      onTap: () async {
                        await _signInWithEmailAndPassword();
                        if (_auth.currentUser != null) {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        }
                      },
                      text: 'Log In',
                      bgColor: AppColor.bgColor,
                      borderRadius: 20,
                      height: screenHeight * 0.06,
                      width: screenWidth * 0.9,
                      textColor: AppColor.kWhite,
                      fontSize: screenWidth * 0.04,
                    ),
                    SizedBox(height: screenHeight * 0.03),
                    Padding(
                      padding: EdgeInsets.only(left: screenWidth * 0.01),
                      child: CustomRichText(
                        title: 'Don’t have an account?',
                        subtitle: ' Create here',
                        onTab: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        subtitleTextStyle: GoogleFonts.plusJakartaSans(
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.w600,
                          color: AppColor.kPrimary,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: screenHeight * 0.04),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                //   child: Column(
                //     children: [
                //       DividerRow(title: 'Or Sign In with'),
                //       SizedBox(height: screenHeight * 0.03),
                //       SecondaryButton(
                //         height: screenHeight * 0.07,
                //         textColor: AppColor.kGrayscaleDark100,
                //         width: screenWidth * 0.8,
                //         onTap: () {},
                //         borderRadius: 24,
                //         bgColor: AppColor.kBackground.withOpacity(0.3),
                //         text: 'Continue with Google',
                //         icons: ImagesPath.kGoogleIcon,
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(height: screenHeight * 0.05),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                //   child: TermsAndPrivacyText(
                //     title1: '  By signing up you agree to our',
                //     title2: ' Terms ',
                //     title3: '  and',
                //     title4: ' Conditions of Use',
                //   ),
                // ),
                // SizedBox(height: screenHeight * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImagesPath {
  static String kGoogleIcon = 'assets/googleSymbol.png';
}

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText(
      {super.key,
      required this.title1,
      required this.title2,
      required this.title3,
      this.color2,
      required this.title4});
  final Color? color2;
  final String title1, title2, title3, title4;
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.kWhite)
            .copyWith(
                color: AppColor.kGrayscale40,
                fontWeight: FontWeight.w500,
                fontSize: 14),
        children: [
          TextSpan(
            text: title1,
          ),
          TextSpan(
            text: title2,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite)
                .copyWith(
                    color: color2 ?? AppColor.kGrayscaleDark100,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
          ),
          TextSpan(
            text: title3,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite)
                .copyWith(
                    color: AppColor.kGrayscale40,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
          ),
          TextSpan(
            text: title4,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite)
                .copyWith(
                    color: AppColor.kGrayscaleDark100,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class SecondaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text, icons;
  final double width;
  final double height;
  final double borderRadius;
  final double? fontSize;
  final Color textColor, bgColor;
  const SecondaryButton(
      {super.key,
      required this.onTap,
      required this.text,
      required this.width,
      required this.height,
      required this.icons,
      required this.borderRadius,
      this.fontSize,
      required this.textColor,
      required this.bgColor});

  @override
  State<SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
          height: widget.height,
          alignment: Alignment.center,
          width: widget.width,
          decoration: BoxDecoration(
            color: widget.bgColor,
            border: Border.all(color: AppColor.kLine),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: Row(
            children: [
              Image.asset(widget.icons, width: 23.85, height: 23.04),
              const SizedBox(width: 12),
              Text(widget.text,
                  style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColor.kWhite)
                      .copyWith(
                    color: widget.textColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

class DividerRow extends StatelessWidget {
  final String title;
  const DividerRow({
    required this.title,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 2,
            child: Divider(
              color: AppColor.kLine,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite)
                .copyWith(
                    color: AppColor.kGrayscale40,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
          ),
        ),
        Expanded(
            flex: 2,
            child: Divider(
              color: AppColor.kLine,
            ))
      ],
    );
  }
}

class CustomRichText extends StatelessWidget {
  const CustomRichText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTab,
    required this.subtitleTextStyle,
  });
  final String title, subtitle;
  final TextStyle subtitleTextStyle;
  final VoidCallback onTab;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: title,
          style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.kWhite)
              .copyWith(
                  color: AppColor.kGrayscale40,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
          children: <TextSpan>[
            TextSpan(
              text: subtitle,
              style: subtitleTextStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  final VoidCallback onTap;
  final String text;
  final double? width;
  final double? height;
  final double? borderRadius, elevation;
  final double? fontSize;
  final IconData? iconData;
  final Color? textColor, bgColor;
  const PrimaryButton(
      {Key? key,
      required this.onTap,
      required this.text,
      this.width,
      this.height,
      this.elevation = 5,
      this.borderRadius,
      this.fontSize,
      required this.textColor,
      required this.bgColor,
      this.iconData})
      : super(key: key);

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Tween<double> _tween = Tween<double>(begin: 1.0, end: 0.95);
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) {
          _controller.reverse();
        });
        widget.onTap();
      },
      child: ScaleTransition(
        scale: _tween.animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
            reverseCurve: Curves.easeIn,
          ),
        ),
        child: Card(
          elevation: widget.elevation ?? 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
          ),
          child: Container(
            height: widget.height ?? 55,
            alignment: Alignment.center,
            width: widget.width ?? double.maxFinite,
            decoration: BoxDecoration(
              color: widget.bgColor,
              borderRadius: BorderRadius.circular(widget.borderRadius!),
            ),
            child: Text(
              widget.text,
              style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColor.kWhite)
                  .copyWith(
                      color: widget.textColor,
                      fontWeight: FontWeight.w500,
                      fontSize: widget.fontSize),
            ),
          ),
        ),
      ),
    );
  }
}

class PrimaryTextButton extends StatelessWidget {
  const PrimaryTextButton(
      {super.key,
      required this.onPressed,
      required this.title,
      required this.textStyle});
  final Function() onPressed;
  final String title;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final String hintText;

  final double width, height;
  final TextEditingController controller;
  final BorderRadiusGeometry borderRadius;
  const PasswordTextField(
      {Key? key,
      required this.hintText,
      required this.height,
      required this.controller,
      required this.width,
      required this.borderRadius})
      : super(key: key);
  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    InputBorder enabledBorder = InputBorder.none;
    InputBorder focusedErrorBorder = InputBorder.none;
    InputBorder errorBorder = InputBorder.none;
    InputBorder focusedBorder = InputBorder.none;

    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          color: AppColor.kBackground2,
          border: Border.all(color: AppColor.kLine)),
      child: TextFormField(
          obscureText: _obscureText,
          controller: widget.controller,
          style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.kWhite)
              .copyWith(
            color: AppColor.kGrayscaleDark100,
          ),
          decoration: InputDecoration(
            filled: true,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColor.kGrayscaleDark100,
                size: 17,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            ),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColor.kWhite)
                .copyWith(
                    color: AppColor.kGrayscale40,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: focusedErrorBorder,
          )),
    );
  }
}

class PrimaryTextFormField extends StatelessWidget {
  PrimaryTextFormField(
      {super.key,
      required this.hintText,
      this.keyboardType,
      required this.controller,
      required this.width,
      required this.height,
      this.hintTextColor,
      this.onChanged,
      this.onTapOutside,
      this.prefixIcon,
      this.prefixIconColor,
      this.inputFormatters,
      this.maxLines,
      this.borderRadius});
  final BorderRadiusGeometry? borderRadius;

  final String hintText;

  final List<TextInputFormatter>? inputFormatters;
  Widget? prefixIcon;
  Function(PointerDownEvent)? onTapOutside;
  final Function(String)? onChanged;
  final double width, height;
  TextEditingController controller;
  final Color? hintTextColor, prefixIconColor;
  final TextInputType? keyboardType;
  final int? maxLines;
  @override
  Widget build(BuildContext context) {
    InputBorder enabledBorder = InputBorder.none;
    InputBorder focusedErrorBorder = InputBorder.none;
    InputBorder errorBorder = InputBorder.none;
    InputBorder focusedBorder = InputBorder.none;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: AppColor.kBackground,
          border: Border.all(color: AppColor.kLine)),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColor.kWhite)
            .copyWith(
          color: AppColor.kGrayscaleDark100,
        ),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          filled: true,
          hintText: hintText,
          hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColor.kWhite)
              .copyWith(
                  color: AppColor.kGrayscaleDark100,
                  fontWeight: FontWeight.w600,
                  fontSize: 14),
          prefixIcon: prefixIcon,
          prefixIconColor: prefixIconColor,
          enabledBorder: enabledBorder,
          focusedBorder: focusedBorder,
          errorBorder: errorBorder,
          focusedErrorBorder: focusedErrorBorder,
        ),
        onChanged: onChanged,
        inputFormatters: inputFormatters,
        onTapOutside: onTapOutside,
      ),
    );
  }
}
