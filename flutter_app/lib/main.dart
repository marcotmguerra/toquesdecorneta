import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'data/storage.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final storage = await Storage.init();
  runApp(MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  final Storage storage;
  const MyApp({super.key, required this.storage});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Storage>.value(value: storage),
        ChangeNotifierProvider(create: (_) => AppProvider(storage)..initTheme()),
      ],
      child: Consumer<AppProvider>(
        builder: (_, provider, _) => MaterialApp(
          title: 'Toques de Corneta',
          debugShowCheckedModeBanner: false,
          theme:     lightTheme(),
          darkTheme: darkTheme(),
          themeMode: provider.darkMode ? ThemeMode.dark : ThemeMode.light,
          home: storage.onboardingConcluido
              ? const HomeScreen()
              : const OnboardingScreen(),
        ),
      ),
    );
  }
}
