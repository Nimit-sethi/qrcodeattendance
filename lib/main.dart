import 'package:attendanceapp/adminpage.dart';
import 'package:attendanceapp/homescreen.dart';
import 'package:attendanceapp/loginscreen.dart';
import 'package:attendanceapp/model/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/admin.dart';
import 'model/admin.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const KeyboardVisibilityProvider(
        child: AuthCheck(),
      ),
      localizationsDelegates: const [
        MonthYearPickerLocalizations.delegate,
      ],
    );
  }
}

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  bool userAvailable = false;
  bool adminAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();

    _getCurrentUser();
  }

  void _getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      // if (sharedPreferences.getString('admin') != null) {
      //   setState(() {
      //     Admin.id = sharedPreferences.getString('admin')!;
      //     // userAvailable = true;
      //     adminAvailable = true;
      //   });
      // }
      if (sharedPreferences.getString('employeeId') != null) {
        if (sharedPreferences.getString('employeeId') == "admin") {
          setState(() {
            Admin.id = sharedPreferences.getString('employeeId')!;
            userAvailable = true;
            adminAvailable = true;
          });
        } else {
          setState(() {
            User.employeeId = sharedPreferences.getString('employeeId')!;
            userAvailable = true;
            adminAvailable = false;
          });
        }
      }
      // else if (sharedPreferences.getString('employeeId') == null &&
      //     sharedPreferences.getString('admin') == null) {
      //   setState(() {
      //     userAvailable = false;
      //     adminAvailable = false;
      //   });
      // }
    } catch (e) {
      setState(() {
        userAvailable = false;
        adminAvailable = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return userAvailable
        ? (adminAvailable ? const AdminPage() : const HomeScreen())
        : LoginScreen();
  }
}
