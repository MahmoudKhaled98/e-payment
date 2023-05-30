import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:e_payment/src/business_logic/auth/code_handling.dart';
import 'package:e_payment/src/business_logic/auth/sign_out.dart';
import 'package:e_payment/src/business_logic/auth/subscription_handle.dart';
import 'package:e_payment/src/business_logic/image_provider.dart';
import 'package:e_payment/src/business_logic/loading_state.dart';
import 'package:e_payment/src/business_logic/navigate_to_screen.dart';
import 'package:e_payment/src/business_logic/request_activation_code.dart';
import 'package:e_payment/src/presentation/screen/receipts_history_screen.dart';
import 'package:e_payment/src/presentation/screen/sign_in_screen.dart';
import 'package:e_payment/src/presentation/widget/confirm_action_button.dart';
import 'package:e_payment/src/presentation/widget/rounded_button.dart';
import '../../business_logic/auth/one_session_login.dart';
import '../../business_logic/auth/sign_in_provider.dart';
import '../../business_logic/auth/signup_provider.dart';
import '../../business_logic/recognize_photo_text.dart';
import '../../business_logic/retrieve_user_data.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PhotoProvider photoProvider = Provider.of<PhotoProvider>(context);
    final SubscriptionHandle subscriptionHandle = SubscriptionHandle();
    final CodeHandling codeHandling = Provider.of<CodeHandling>(context);
    final RecognizeText recognizeText = Provider.of<RecognizeText>(context);
    final ConfirmingPhotoLoadingState confirmingPhotoLoadingState =
        Provider.of<ConfirmingPhotoLoadingState>(context);
    RetrieveUserDataProvider retrieveUserDataProvider =
        Provider.of<RetrieveUserDataProvider>(context);
    retrieveUserDataProvider.getUserDataFromFirestore();
    OneSessionLogin oneSessionLogin = Provider.of<OneSessionLogin>(context);
    SignInProvider signInProvider = Provider.of<SignInProvider>(context);
    SignupProvider signupProvider = Provider.of<SignupProvider>(context);
    final auth = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(0, 0, 254, 1),
      ),
      drawer: SizedBox(
        width: 250,
        child: Drawer(
          backgroundColor: const Color.fromRGBO(0, 0, 200, 2).withOpacity(0.50),
          child: Padding(
            padding: const EdgeInsets.only(top: 15),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child: GestureDetector(
                    onTap: () async {
                      HapticFeedback.vibrate();
                        NavigateToScreen().navToScreen(
                            context, const ReceiptsHistoryScreen());

                    },
                    child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 40, 0.8, 0.8),
                            child: Icon(
                              Icons.access_time,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 40, 0.8, 0.8),
                            child: Text("Receipts History",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                )),
                          ),

                        ]),
                  ),
                ), // receipts history
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.vibrate();

                      RequestCode().launchInBrowser(
                          Uri.parse("http://m.me/enegosyoofficial"));
                    },
                    child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 40, 0.8, 0.8),
                            child: Icon(
                              Icons.help,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(8.0, 40, 0.8, 0.8),
                            child: Text("Help Or Support",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white,
                                )),
                          ),

                        ]),
                  ),
                ), //help or support
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 40, 0.8, 0.8),
                          child: Icon(
                            Icons.email,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8.0, 40, 0.8, 0.8),
                          child: SizedBox(
                            width: 200,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child:

                       Text("${auth.currentUser!.email}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.white,
                                  ))
                            ),
                          ),
                        ),
                      ]),
                ),//userEmail
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 1, 0, 10),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8.0, 40, 0.8, 0.8),
                          child: Icon(
                            Icons.calendar_month,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(1.0, 40, 0.8, 0.8),
                          child: retrieveUserDataProvider.subscriptionEndDate
                                  .isAfter(DateTime(2100 - 01 - 1))
                              ? const Text("End date:   Life time ",
                                  style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                  ))
                              : Text(
                                  "End date: ${retrieveUserDataProvider.formattedSubscriptionEndDate}",
                                  style: const TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Colors.white,
                                  )),
                        ),

                      ]),
                ), //end date
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 20, 0, 10),
                  child: GestureDetector(
                    onTap: () async {
                      HapticFeedback.vibrate();
                      SignOut().signOut();
                      NavigateToScreen()
                          .navToScreen(context, const SignInScreen());
                      oneSessionLogin.notLoggedIn();
                      oneSessionLogin
                          .sendSessionData(auth.currentUser!.email);
                      if (signInProvider.userEmail != "") {
                        oneSessionLogin.notLoggedIn();
                        return await oneSessionLogin
                            .sendSessionData(signInProvider.userEmail);
                      } else {
                        oneSessionLogin.notLoggedIn();
                        await oneSessionLogin
                            .sendSessionData(signupProvider.userEmail);
                      }
                    },
                    child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.exit_to_app_rounded,
                              size: 21,
                              color: Colors.red,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text("Logout",
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.red)),
                          ),
                        ]),
                  ),
                ), //sign out
              ],
            ),
          ),
        ),
      ),
      body:WillPopScope(
        onWillPop: () async => false,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: ChangeNotifierProvider(
              create: (_) => PhotoProvider(),
              child: auth.currentUser?.email == "admin@admin.com"
                  ? Padding(
                      padding: const EdgeInsets.only(top: 200),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Center(
                                child: Text(
                              "Add Code",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 0, 254, 1),
                              ),
                            )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 50,
                              width: 100,
                              child: TextField(
                                onChanged: (code) {
                                  codeHandling.getCode(code);
                                },
                                decoration:
                                    const InputDecoration(hintText: "Add Code"),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                HapticFeedback.vibrate();

                                if (codeHandling.code != "" &&
                                    codeHandling.code != '' &&
                                    codeHandling.code != null) {
                                  await codeHandling
                                      .addLifeTimeCodeToFirebase();
                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "Life Time Code Added",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ));
                                } else {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Can Not Add Empty Code !",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      height: 50,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              0, 0, 254, 1),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: const Center(
                                          child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Add Life Time Code",
                                            style: TextStyle(
                                                fontFamily: "Poppins",
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ))),
                                ),
                              ),
                            ),
                          ), //add lifeTimeCode Btn
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(

                              onTap: () async {
                                HapticFeedback.vibrate();

                                if (codeHandling.code != "" &&
                                    codeHandling.code != '' &&
                                    codeHandling.code != null) {
                                  await codeHandling.addOneYearCodeToFirebase();

                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "One Year Code Added !",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ));
                                } else {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Can Not Add Empty Code !",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Container(
                                    height: 50,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(0, 0, 254, 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add One Year Code",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))),
                              ),
                            ),
                          ), // add oneYear Btn
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                HapticFeedback.vibrate();

                                if (codeHandling.code != "" &&
                                    codeHandling.code != '' &&
                                    codeHandling.code != null) {
                                  await codeHandling
                                      .addOneMonthCodeToFirebase();

                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "One Month Code Added !",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ));
                                } else {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Can Not Add Empty Code !",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Container(
                                    height: 50,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(0, 0, 254, 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add One Month Code",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))),
                              ),
                            ),
                          ), // add oneMonth Btn
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () async {
                                HapticFeedback.vibrate();

                                if (codeHandling.code != "" &&
                                    codeHandling.code != '' &&
                                    codeHandling.code != null) {
                                  await codeHandling
                                      .addWeekCodeToFirebase();

                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(const SnackBar(
                                    content: Text(
                                      "One Week Code Added !",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ));
                                } else {
                                  if (!context.mounted) {
                                    return;
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        "Can Not Add Empty Code !",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Center(
                                child: Container(
                                    height: 50,
                                    width: 200,
                                    decoration: BoxDecoration(
                                        color:
                                            const Color.fromRGBO(0, 0, 254, 1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Center(
                                        child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Add One Week Code",
                                          style: TextStyle(
                                              fontFamily: "Poppins",
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ))),
                              ),
                            ),
                          ), // add oneWeek Btn
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: photoProvider.photo == null
                              ? Image.asset("assets/images/no-image-icon.png")
                              : SizedBox(
                                  height: 550,
                                  width: 400,
                                  child: Image.file(photoProvider.photo!)),
                        ),
                        photoProvider.photo != null
                            ? confirmingPhotoLoadingState.isLoading
                                ? const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircularProgressIndicator(
                                          color: Colors.green),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        "Loading...",
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontFamily: "Poppins",
                                        ),
                                      )
                                    ],
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RoundedButton(
                                          onTap: () async {
                                            confirmingPhotoLoadingState
                                                .loading();
                                            await recognizeText.recognizingText(
                                                photoProvider.photo);

                                            await subscriptionHandle
                                                .detectSubscriptionState(
                                                    context);
                                            confirmingPhotoLoadingState
                                                .notLoading();
                                          },
                                          icon: const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                          color: Colors.green,
                                        ),
                                        RoundedButton(
                                          onTap: () {
                                            photoProvider.deletePhoto();
                                            recognizeText.scannedText = '';
                                          },
                                          icon: const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                            size: 40,
                                          ),
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                  )
                            : Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ConfirmActionButton(
                                    onPressed: () async {
                                      HapticFeedback.vibrate();

                                      if (await Permission.storage.isGranted) {
                                        await photoProvider.pickPhoto();
                                      } else {
                                        await Permission.storage.request();
                                      }
                                    },
                                    buttonText: const Text(
                                      "Upload Photo",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ConfirmActionButton(
                                    onPressed: () async {
                                      HapticFeedback.vibrate();

                                      if (await Permission.camera.isGranted) {
                                        await photoProvider.takePhoto();
                                      } else {
                                        await Permission.camera.request();
                                      }
                                    },
                                    buttonText: const Text(
                                      "Take Photo",
                                      style: TextStyle(
                                        fontFamily: "Poppins",
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 60,
                                  ),
                                ],
                              ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

//WillPopScope(
//       onWillPop: ()async =>false,
//       child: Column(),
//     );
