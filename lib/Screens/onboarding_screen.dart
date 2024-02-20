import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healwiz/Screens/login.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroductionPageView extends StatefulWidget {
  const IntroductionPageView({Key? key}) : super(key: key);

  @override
  State<IntroductionPageView> createState() => _IntroductionPageViewState();
}

class _IntroductionPageViewState extends State<IntroductionPageView> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          flex: 3,
          child: PageView.builder(
            controller: pageController,
            itemCount: listOfItems.length,
            onPageChanged: (newIndex) {
              setState(() {
                currentIndex = newIndex;
              });
            },
            physics: const BouncingScrollPhysics(),
            itemBuilder: ((context, index) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(15, 40, 15, 10),
                    width: 500,
                    height: 325,
                    child: CustomAnimatedWidget(
                      index: index,
                      delay: 100,
                      child: Image.asset(listOfItems[index].img),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: CustomAnimatedWidget(
                        index: index,
                        delay: 300,
                        child: Text(
                          listOfItems[index].title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                              color: Colors.black, fontSize: 26),
                        ),
                      )),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: CustomAnimatedWidget(
                      index: index,
                      delay: 500,
                      child: Text(
                        listOfItems[index].subTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                            fontSize: 17, fontWeight: FontWeight.w300),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SmoothPageIndicator(
                controller: pageController,
                count: listOfItems.length,
                effect: const ExpandingDotsEffect(
                  spacing: 6.0,
                  radius: 10.0,
                  dotWidth: 10.0,
                  dotHeight: 10.0,
                  expansionFactor: 3.8,
                  dotColor: Colors.grey,
                  activeDotColor: Colors.deepPurple,
                ),
                onDotClicked: (newIndex) {
                  setState(() {
                    currentIndex = newIndex;
                    pageController.animateToPage(newIndex,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  });
                },
              ),
              const SizedBox(
                height: 90,
              ),
              currentIndex == 2
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: PrimaryButton(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignInScreen()),
                          );
                        },
                        text: 'Get Started',
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: PrimaryButton(
                        onTap: () {
                          setState(() {
                            pageController.animateToPage(2,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.fastOutSlowIn);
                          });
                        },
                        text: 'Skip',
                      ),
                    ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    ));
  }
}

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const PrimaryButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            fixedSize: const Size(double.maxFinite, 53),
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: Text(
          text,
          style: GoogleFonts.poppins(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ));
  }
}

class CustomAnimatedWidget extends StatelessWidget {
  final int index;
  final int delay;
  final Widget child;
  const CustomAnimatedWidget(
      {super.key,
      required this.index,
      required this.delay,
      required this.child});

  @override
  Widget build(BuildContext context) {
    if (index == 1) {
      return FadeInDown(
        delay: Duration(milliseconds: delay),
        child: child,
      );
    }
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: child,
    );
  }
}

class Items {
  final String img;
  final String title;
  final String subTitle;

  ///
  Items({
    required this.img,
    required this.title,
    required this.subTitle,
  });
}

List<Items> listOfItems = [
  Items(
    img: "assets/1.png",
    title: "Welcome to HealWiz!",
    subTitle: "Revolutionize the way you manage your health, starting now",
  ),
  Items(
    img: "assets/2.png",
    title: "Explore Advanced Healthcare Solutions",
    subTitle:
        "Access all essential healthcare tools in one convenient place- no more switching between the apps!",
  ),
  Items(
    img: "assets/3.png",
    title: " Instant Disease Analysis",
    subTitle:
        "Scan images for accurate disease identification and personalized prescriptions.",
  ),
];
