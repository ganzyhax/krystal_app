import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:sauna_krystal/app/screens/home/bloc/home_bloc.dart';
import 'package:sauna_krystal/app/screens/home/home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeLoaded) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Crystal Sauna',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(
                    width: 100,
                    child: LoadingIndicator(
                        colors: [Colors.black],
                        strokeWidth: 3,
                        indicatorType: Indicator.ballRotate
                        // pathBackgroundColor: Colors.black45,
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
