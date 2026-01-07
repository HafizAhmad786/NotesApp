import 'package:flutter/material.dart';
import 'package:notes_app/components/custom_textfield.dart';
import 'package:notes_app/screens/auth/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:notes_app/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthProvider authProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    authProvider = AuthProvider();
  }

  @override
  void dispose() {
    super.dispose();
    authProvider.email.dispose();
    authProvider.password.dispose();
    authProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: authProvider,
      child: Builder(
        builder: (_) {
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.42,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: .center,
                          child: Text(
                            'Welcome Back',
                            style: TextStyle(fontSize: 33),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              CustomTextField(
                                title: "Login",
                                controller: authProvider.email,
                              ),
                              const SizedBox(height: 10),
                              Selector<AuthProvider, bool>(
                                builder: (_, isShowing, child) {
                                  return CustomTextField(
                                    title: "Password",
                                    controller: authProvider.password,
                                    showPassword: isShowing,
                                    iconButton: IconButton(
                                      onPressed: () =>
                                          authProvider.showPassword(),
                                      icon: Icon(
                                        isShowing
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                      ),
                                    ),
                                  );
                                },
                                selector: (_, controller) =>
                                    controller.isShowing,
                              ),
                              const SizedBox(height: 40),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 27,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Selector<AuthProvider, bool>(
                                    selector: (_, controller) =>
                                        controller.isLoading,
                                    builder: (_, isLoading, child) {
                                      return CircleAvatar(
                                        radius: 30,
                                        backgroundColor: const Color(
                                          0xff4c505b,
                                        ),
                                        child: isLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : IconButton(
                                                color: Colors.white,
                                                onPressed: () async {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    await authProvider.login(
                                                      context,
                                                      authProvider.email.text,
                                                      authProvider
                                                          .password
                                                          .text,
                                                    );
                                                  }
                                                },
                                                icon: const Icon(
                                                  Icons.arrow_forward,
                                                ),
                                              ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Align(
                                alignment: .centerLeft,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ),
                                    );
                                  },
                                  style: const ButtonStyle(),
                                  child: Text(
                                    'Sign Up',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Color(0xff4c505b),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
