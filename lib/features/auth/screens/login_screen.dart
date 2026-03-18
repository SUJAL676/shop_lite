import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_lite/core/widget/animated_toast.dart';
import 'package:shop_lite/features/auth/bloc/auth_bloc.dart';
import 'package:shop_lite/features/catalog/screens/catalog_screen.dart';
import '../../../../../core/storage/secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;
  bool rememberMe = false;

  SecureStorage storage = SecureStorage();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final padding = size.width * 0.05;
    final borderRadius = size.width * 0.07;
    final fieldRadius = size.width * 0.04;
    final spacingSmall = size.height * 0.01;
    final spacingMedium = size.height * 0.02;
    final spacingLarge = size.height * 0.035;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(size.width * 0.04),
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) async {
                if (state is AuthSuccess) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CatalogScreen(
                        username: state.cred["user_name"],
                        userphoto: state.cred["user_photo"],
                      ),
                    ),
                  );
                }

                if (state is AuthFailure) {
                  showAnimatedToast(context, message: state.message);
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.03),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4B266),
                          borderRadius: BorderRadius.circular(
                            size.width * 0.04,
                          ),
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          color: Colors.white,
                          size: size.width * 0.07,
                        ),
                      ),
                    ),

                    SizedBox(height: spacingMedium),
                    Center(
                      child: Text(
                        "ShopLite",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          letterSpacing: size.width * 0.01,
                          fontSize: size.width * 0.045,
                        ),
                      ),
                    ),

                    SizedBox(height: spacingLarge),
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: size.width * 0.065,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    SizedBox(height: spacingSmall),

                    Center(
                      child: Text(
                        "Please enter your details to sign in",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: size.width * 0.035,
                        ),
                      ),
                    ),

                    SizedBox(height: spacingLarge),
                    Text(
                      "User Name",
                      style: TextStyle(fontSize: size.width * 0.04),
                    ),

                    SizedBox(height: spacingSmall),

                    TextField(
                      controller: emailController,
                      style: TextStyle(fontSize: size.width * 0.04),
                      decoration: InputDecoration(
                        hintText: "enter user name",
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(fieldRadius),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    SizedBox(height: spacingMedium),
                    Text(
                      "Password",
                      style: TextStyle(fontSize: size.width * 0.04),
                    ),

                    SizedBox(height: spacingSmall),

                    TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      style: TextStyle(fontSize: size.width * 0.04),
                      decoration: InputDecoration(
                        hintText: "enter password",
                        filled: true,
                        fillColor: const Color(0xFFF3F3F3),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(fieldRadius),
                          borderSide: BorderSide.none,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            size: size.width * 0.05,
                          ),
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),

                    SizedBox(height: spacingLarge),

                    state is AuthLoading
                        ? Center(
                            child: SizedBox(
                              height: size.width * 0.3,
                              child: LottieBuilder.asset(
                                "assets/animation_file/loading_wave.json",
                              ),
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFF4B266),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    size.width * 0.05,
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.02,
                                ),
                              ),
                              onPressed: () {
                                final email = emailController.text.trim();
                                final password = passwordController.text.trim();

                                if (email.isEmpty || password.isEmpty) {
                                  showAnimatedToast(
                                    context,
                                    message: "Enter all fields",
                                  );
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   const SnackBar(
                                  //     content: Text("Enter all fields"),
                                  //   ),
                                  // );
                                  return;
                                }

                                context.read<AuthBloc>().add(
                                  LoginRequested(email, password),
                                );
                              },
                              child: Text(
                                "Login to Account",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: size.width * 0.045,
                                ),
                              ),
                            ),
                          ),

                    SizedBox(height: spacingLarge),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
