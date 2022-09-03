import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import "package:flutter/material.dart";
import 'package:login_screen_flutter/screens/upload_page.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // form key...
  final _formKey = GlobalKey<FormState>();

  static Future<User?> loginUsingEmailPassword({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'User not found') {
        debugPrint("No user found for that email");
      }
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
// editing controller...
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(0),
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 200,
                      child:
                          Image.asset('assets/butterfly.png', fit: BoxFit.fill),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      //validator: (){},
                      onSaved: (value) {
                        emailController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: "Eamil",
                        prefixIcon: const Icon(Icons.mail),
                        border: OutlineInputBorder(
                          gapPadding: 20,
                          borderSide: const BorderSide(
                            width: 10,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      autofocus: false,
                      controller: passController,
                      keyboardType: TextInputType.visiblePassword,
                      //validator: (){},
                      onSaved: (value) {
                        passController.text = value!;
                      },
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Password",
                        prefixIcon: const Icon(Icons.key),
                        border: OutlineInputBorder(
                          gapPadding: 20,
                          borderSide: const BorderSide(
                            width: 10,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Material(
                      elevation: 10,
                      borderRadius: BorderRadius.circular(30),
                      child: MaterialButton(
                        onPressed: () async {
                          User? user = await loginUsingEmailPassword(
                            email: emailController.text,
                            password: passController.text,
                            context: context,
                          );
                          debugPrint(user.toString());
                          if (user != null) {
                            // ignore: use_build_context_synchronously
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const UploadPage(),
                              ),
                            );
                          }
                        },
                        color: Colors.amber,
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
                        minWidth: double.infinity,
                        child: const Text(
                          "Log in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
