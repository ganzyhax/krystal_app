import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:sauna_krystal/app/app.dart';
import 'package:sauna_krystal/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions
        .currentPlatform, // Add platform-specific initialization here
  );
  initializeDateFormatting('ru_RU', null);
  runApp(SaunaKrystalApp());
}
