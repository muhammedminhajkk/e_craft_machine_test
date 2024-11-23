import 'package:e_craft_machine_test/features/home_page/home_page.dart';
import 'package:e_craft_machine_test/features/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    void onSignupLinkClicked() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }

    /// Callback to execute when the login button clicked
    Future<void> signUp(
        String email, String password, String confirmPassword) async {
      void onSuccess() {
        {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomePage(
                      user: email.split('@')[0],
                    )),
          );
        }
      }

      if (password == confirmPassword) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          onSuccess();
          print('User registered successfully');
        } on FirebaseAuthException catch (e) {
          print('Failed to register: ${e.message}');
        }
      } else {
        print('Password and Confirm Password are not same');
      }
    }

    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Login'),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'Email',
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  signUp(emailController.text, passwordController.text,
                      confirmPasswordController.text);
                  emailController.clear();
                  passwordController.clear();
                  confirmPasswordController.clear();
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Already have an account?'),
                  TextButton(
                    onPressed: onSignupLinkClicked,
                    child: const Text('Sign up'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
