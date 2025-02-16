import "package:blog_app/core/theme/app_pallete.dart";
import "package:blog_app/features/auth/presentation/pages/login_page.dart";
import "package:blog_app/features/auth/presentation/widgets/auth_button.dart";
import "package:blog_app/features/auth/presentation/widgets/auth_field.dart";
import "package:flutter/material.dart";

class SignupPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => SignupPage(),
      );
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    emailController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Sign Up.',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              AuthField(hinttext: 'Name', controller: nameController),
              SizedBox(height: 20),
              AuthField(hinttext: 'Email', controller: emailController),
              SizedBox(height: 20),
              AuthField(
                  hinttext: 'Password',
                  controller: passwordController,
                  isObscureText: true),
              SizedBox(height: 30),
              AuthButton(
                buttonText: 'Sign Up',
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    LoginPage.route(),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    style: Theme.of(context).textTheme.titleMedium,
                    children: [
                      TextSpan(
                        text: " Sign In",
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppPallete.gradient2,
                                  fontWeight: FontWeight.bold,
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
    );
  }
}
