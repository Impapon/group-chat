import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_day36/auth/firebase_auth.dart';
import 'package:firebase_day36/models/user_model.dart';
import 'package:firebase_day36/pages/profile_page.dart';
import 'package:firebase_day36/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLogin = true, isObscureText = true;
  final formKey = GlobalKey<FormState>();
  String errMsg = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "This filed cant be empty";
                  } else {
                    return null;
                  }
                },
              ),
              TextFormField(
                controller: passwordController,
                obscureText: isObscureText,
                decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.password),
                    suffix: IconButton(
                      icon: Icon(isObscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isObscureText = !isObscureText;
                        });
                      },
                    )),
              ),
              SizedBox(
                height: 16,
              ),
              ElevatedButton(
                  onPressed: () {
                    isLogin = true;
                    authenticate();
                  },
                  child: Text("Login")),
              Row(
                children: [
                  Text("New User ? "),
                  TextButton(
                      onPressed: () {
                        isLogin = false;
                        authenticate();
                      },
                      child: Text("Regiter here User ? ")),
                ],
              ),
              Row(
                children: [
                  Text("Forget Password ? "),
                  TextButton(onPressed: () {}, child: Text("Reset?")),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Text(errMsg),
            ],
          ),
        ),
      ),
    );
  }

  void authenticate() async {
    if (formKey.currentState!.validate()) {
      bool status;
      try {
        if (isLogin) {
          status = await AuthService.login(
              emailController.text, passwordController.text);
        } else {
          status = await AuthService.register(
              emailController.text, passwordController.text);
          final userModel = UserModel(
              uid: AuthService.user!.uid, email: AuthService.user!.email!);
          if (mounted) {
            await Provider.of<UserProvider>(context, listen: false)
                .addUser(userModel);
            Navigator.pushReplacementNamed(context, ProfilePage.routeName);
          }
        }
        if (status) {
          Navigator.pushReplacementNamed(context, ProfilePage.routeName);
        }
      } on FirebaseAuthException catch (error) {
        print(error);
        setState(() {
          errMsg = error.message!;
        });
      }
    }
  }
}
