import 'package:flutter/material.dart';

import 'home.dart';
import 'style/colors.dart';
import 'style/theme.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void entrar() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const Home(),
        transitionsBuilder: (_, animation, __, child) => FadeTransition(
          opacity: animation,
          child: child,
        ),
        transitionDuration: const Duration(milliseconds: 450),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final escuro = AppTheme.modo.value == ThemeMode.dark;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fade,
            child: ScaleTransition(
              scale: _scale,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: escuro ? const Color(0xFF243B53) : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(blurRadius: 18, offset: Offset(0, 8), color: Colors.black26),
                        ],
                      ),
                      child: Image.asset('assets/icone.png'),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Pessoas',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.azul,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cadastro de pessoas',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 28),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Tema escuro'),
                      value: escuro,
                      onChanged: (value) {
                        setState(() {
                          AppTheme.modo.value = value ? ThemeMode.dark : ThemeMode.light;
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: entrar,
                        icon: const Icon(Icons.login),
                        label: const Text('Entrar'),
                      ),
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
