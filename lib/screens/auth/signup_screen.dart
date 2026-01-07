import 'package:flutter/material.dart';
import 'package:notes_app/components/custom_textfield.dart';
import 'package:notes_app/providers/auth_provider.dart';
import 'package:notes_app/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late AuthProvider authProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authProvider = AuthProvider();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    authProvider.name.dispose();
    authProvider.email.dispose();
    authProvider.password.dispose();
    authProvider.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: authProvider,
      child: Builder(
        builder: (_){
          return Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/register.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: .center,
                          child: const Text(
                            'Create Account',
                            style: TextStyle(color: Colors.white, fontSize: 33),
                          ),
                        ),
                        const SizedBox(height: 22),
                        Container(
                          margin: const EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              const SizedBox(height: 30),
                              CustomTextField(
                                title: "Name",
                                controller: authProvider.name,
                              ),
                              const SizedBox(height: 30),
                              CustomTextField(
                                title: "Login",
                                controller: authProvider.email,
                              ),
                              const SizedBox(height: 30),
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
                                    'Sign Up',
                                    style: TextStyle(
                                      color: Colors.white,
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
                                              await authProvider
                                                  .signUp(context,{
                                                "name": authProvider.name.text,
                                                "email": authProvider.email.text,
                                                "password":
                                                authProvider.password.text,
                                              });

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
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(),
                                  child: Text(
                                    'Sign In',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.white,
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
      )
    );
  }
}
