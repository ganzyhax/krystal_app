import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:sauna_krystal/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting('ru_RU', null);
  runApp(SaunaKrystalApp());
}
