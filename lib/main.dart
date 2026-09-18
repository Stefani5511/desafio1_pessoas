import 'package:flutter/material.dart';

import 'ui/splash.dart';
import 'ui/style/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: AppTheme.modo,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Pessoas',
          theme: AppTheme.temaClaro,
          darkTheme: AppTheme.temaEscuro,
          themeMode: themeMode,
          home: const Splash(),
        );
      },
    ),
  );
}
