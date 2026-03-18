import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_lite/features/auth/screens/login_screen.dart';
import 'package:shop_lite/features/catalog/screens/catalog_screen.dart';
import 'package:shop_lite/features/splash/bloc/splash_bloc.dart';

import '../../../../../core/storage/secure_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;

  SplashBloc bloc = SplashBloc(SecureStorage());

  final SecureStorage storage = SecureStorage();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    opacityAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _controller.forward();

    Future.delayed(Duration(seconds: 2)).then((v) {
      bloc.add(CheckAuthStatus());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleNavigation(BuildContext context, SplashState state) {
    if (state is SplashAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => CatalogScreen(
            username: state.cred["user_name"],
            userphoto: state.cred["user_photo"],
          ),
        ),
      );
    } else if (state is SplashUnauthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocListener<SplashBloc, SplashState>(
        bloc: bloc,
        listener: _handleNavigation,
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (_, _) {
              return Opacity(
                opacity: opacityAnimation.value,
                child: Transform.scale(
                  scale: scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF4B266),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.shopping_bag,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 20),
                      const Text(
                        "SHOPLITE",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3,
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Text(
                        "Smart Shopping Experience",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
