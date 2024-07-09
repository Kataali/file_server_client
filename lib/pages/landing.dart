import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_server/pages/admin_login.dart';
import 'package:file_server/pages/login.dart';
import 'package:file_server/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/api_model.dart';

class LandingPage extends StatefulWidget {
  static const routeName = '/landing';
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool isLoading = false;
  final CarouselController carouselController = CarouselController();
  bool showPassword = false;
  final String serverEndPoint = Api.userEndpoint;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final carouselDescriptions = [
    "Easily Send Files To an Email Right in the App"
        "Download files with just a  click"
        "Find files of different formats with Ease"
  ];

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    // final deviceHeight = MediaQuery.of(context).size.height;
    // final deviceWidth = MediaQuery.of(context).size.width;
    ['assets/images/attach.png', 'assets/images/download.png'];

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: BlurryModalProgressHUD(
          inAsyncCall: isLoading,
          dismissible: false,
          child: GestureDetector(
            onTap: () {
              SystemChannels.textInput.invokeMethod<void>('TextInput.hide');
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child:
                    // const Divider(
                    //   height: 30,
                    //   thickness: .001,
                    // ),
                    Center(
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: SizedBox(
                        width: 700,
                        child: Column(
                          children: [
                            CarouselSlider(
                              carouselController: carouselController,
                              options: CarouselOptions(
                                  // height: 300.0,
                                  aspectRatio: 8 / 4,
                                  enableInfiniteScroll: true,
                                  // aspectRatio: 3 / 4,
                                  padEnds: true,
                                  autoPlay: true),
                              items: [
                                {
                                  'assets/images/attach.png',
                                  "Easily send Files as Email attachments right in the App",
                                },
                                {
                                  'assets/images/download.png',
                                  "Download files with just a  click",
                                },
                                {
                                  'assets/images/folder.png',
                                  "Find files of different formats with Ease"
                                },
                              ].map((i) {
                                return Builder(
                                  builder: (BuildContext context) {
                                    return Column(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 70.0),
                                            child: Container(
                                              width: double.infinity,
                                              // margin:
                                              //     const EdgeInsets.symmetric(
                                              //         horizontal: 15.0),
                                              decoration: ShapeDecoration(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                // color: color.primary,
                                                image: DecorationImage(
                                                  image: AssetImage(i.first),
                                                  fit: BoxFit.scaleDown,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const Divider(
                                          height: 10,
                                          thickness: .001,
                                        ),
                                        Text(
                                          i.last,
                                          style:
                                              //  TextStyle(fontSize: 16.0, color: color.secondary, ),
                                              GoogleFonts.playfair(
                                                  color: color.secondary,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                            const Divider(
                              height: 30,
                              thickness: .001,
                            ),
                            Container(
                              decoration: ShapeDecoration(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                color: color.onPrimary,
                              ),
                              padding: const EdgeInsets.all(30),
                              width: 700,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 20.0, top: 20),
                                    child: Text(
                                      'Welcome to Amali File Server',
                                      style: GoogleFonts.playfairDisplay(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w700,
                                          color: color.secondary),
                                    ),
                                  ),
                                  const Divider(
                                    height: 30,
                                    thickness: .001,
                                  ),

                                  // const Divider(
                                  //   height: 30,
                                  //   thickness: .001,
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                        child: MyButton(
                                          onPressed: () async {
                                            Navigator.pushNamed(context,
                                                AdminLoginPage.routeName);
                                          },
                                          text: 'Proceed as Admin',
                                          color: color.onSecondary,
                                          leading: Icon(
                                            Icons.supervisor_account_outlined,
                                            color: color.onPrimary,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                      const VerticalDivider(
                                        width: 15,
                                        thickness: 0.001,
                                      ),
                                      Expanded(
                                        child: MyButton(
                                          onPressed: () async {
                                            Navigator.pushNamed(
                                                context, LoginPage.routeName);
                                          },
                                          text: 'Proceed as User',
                                          leading: Icon(
                                            Icons.person_outlined,
                                            color: color.onPrimary,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 30,
                                    thickness: .001,
                                  ),

                                  // TextButton(
                                  //     onPressed: () {
                                  //       CustomDialog.showPopUp(
                                  //           context,
                                  //           "Text",
                                  //           "Some content",
                                  //           "firstButtonText",
                                  //           null,
                                  //           () {},
                                  //           () {});
                                  //     },
                                  //     child: const Text("Test"))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
