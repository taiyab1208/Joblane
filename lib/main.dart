import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/job_list_screen.dart';
import 'screens/post_job_screen.dart';
import 'screens/employer_dashboard.dart';
import 'screens/profile_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(JoblaneApp());
}

class JoblaneApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JOBLANE',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: AppColors.accent,
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: AppColors.text),
        ),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/jobs': (context) => JobListScreen(),
        '/post-job': (context) => PostJobScreen(),
        '/employer-dashboard': (context) => EmployerDashboard(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}