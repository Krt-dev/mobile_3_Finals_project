import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:tic_tac_toe/src/controllers/auth_controller.dart';
import 'package:tic_tac_toe/src/dialogs/waiting_dialog.dart';
import 'package:tic_tac_toe/src/routing/router.dart';

import 'registration.screen.dart';

class LoginScreen extends StatefulWidget {
  static const String route = "/auth";
  static const String name = "Login Screen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController username, password;
  late FocusNode usernameFn, passwordFn;

  bool obfuscate = true;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    username = TextEditingController(text: "kurt.sanchez.20@usjr.edu.ph");
    password = TextEditingController(text: "#Iamawesome45abcABC");
    usernameFn = FocusNode();
    passwordFn = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    username.dispose();
    password.dispose();
    usernameFn.dispose();
    passwordFn.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/tictacBG.png'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 80),
                          child: SizedBox(
                            width: 500,
                            height: 80,
                            child: Image.asset('assets/images/TIC-TAC-TOE.png'),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 60),
                          child: Flexible(
                            child: TextFormField(
                              decoration: decoration.copyWith(
                                  labelText: "Username",
                                  prefixIcon: const Icon(Icons.person),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        40.0), // Adds rounded corners
                                    borderSide: const BorderSide(
                                      width: 15.0, // Sets border width
                                    ),
                                  )),
                              focusNode: usernameFn,
                              controller: username,
                              onEditingComplete: () {
                                passwordFn.requestFocus();
                              },
                              validator: MultiValidator([
                                RequiredValidator(
                                    errorText: 'Please fill out the username'),
                                MaxLengthValidator(32,
                                    errorText:
                                        "Username cannot exceed 32 characters"),
                                EmailValidator(
                                    errorText: "Please select a valid email"),
                              ]).call,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 200),
                          child: Container(
                            padding: const EdgeInsets.only(top: 10),
                            child: Flexible(
                              child: TextFormField(
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: obfuscate,
                                decoration: decoration.copyWith(
                                    labelText: "Password",
                                    prefixIcon: const Icon(Icons.password),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            obfuscate = !obfuscate;
                                          });
                                        },
                                        icon: Icon(obfuscate
                                            ? Icons.remove_red_eye_rounded
                                            : CupertinoIcons.eye_slash))),
                                focusNode: passwordFn,
                                controller: password,
                                onEditingComplete: () {
                                  passwordFn.unfocus();

                                  ///call submit maybe?
                                },
                                validator: MultiValidator([
                                  RequiredValidator(
                                      errorText: "Password is required"),
                                  MinLengthValidator(12,
                                      errorText:
                                          "Password must be at least 12 characters long"),
                                  MaxLengthValidator(128,
                                      errorText:
                                          "Password cannot exceed 72 characters"),
                                  PatternValidator(
                                      r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*()_+?\-=[\]{};':,.<>]).*$",
                                      errorText:
                                          'Password must contain at least one symbol, one uppercase letter, one lowercase letter, and one number.')
                                ]).call,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 3.0),
                          child: Flexible(
                            child: ElevatedButton(
                              onPressed: () {
                                GlobalRouter.I.router
                                    .go(RegistrationScreen.route);
                              },
                              child: const Text("No account? Register"),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 3.0),
                          child: Flexible(
                            child: ElevatedButton(
                                onPressed: () {
                                  onSubmit();
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all(Colors.blue),
                                ),
                                child: const Text(
                                  "Login",
                                  style: TextStyle(color: Colors.white),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onSubmit() {
    if (formKey.currentState?.validate() ?? false) {
      WaitingDialog.show(context,
          future: AuthController.I
              .login(username.text.trim(), password.text.trim()));
    }
  }

  final OutlineInputBorder _baseBorder = const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.grey),
    borderRadius: BorderRadius.all(Radius.circular(4)),
  );

  InputDecoration get decoration => InputDecoration(
      // prefixIconColor: AppColors.primary.shade700,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      filled: true,
      fillColor: Colors.white,
      errorMaxLines: 3,
      disabledBorder: _baseBorder,
      enabledBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.black87, width: 1),
      ),
      focusedBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.blueAccent, width: 1),
      ),
      errorBorder: _baseBorder.copyWith(
        borderSide: const BorderSide(color: Colors.deepOrangeAccent, width: 1),
      ));
}
