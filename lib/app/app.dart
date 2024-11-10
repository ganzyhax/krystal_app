import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sauna_krystal/app/screens/home/bloc/home_bloc.dart';
import 'package:sauna_krystal/app/screens/home/home_screen.dart';
import 'package:sauna_krystal/app/screens/splash/splash_screen.dart';

class SaunaKrystalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(
          create: (BuildContext context) => HomeBloc()..add(HomeLoad()),
        ),
      ],
      child: MaterialApp(
        title: 'Sauna Krystal',
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
