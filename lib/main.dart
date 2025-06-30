import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/service_bloc.dart';
import 'bloc/service_event.dart';
import 'bloc/onboarding_cubit.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const InfoViewerApp());
}

class InfoViewerApp extends StatelessWidget {
  const InfoViewerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ServiceBloc>(
          create: (_) => ServiceBloc()..add(FetchServices()),
        ),
        BlocProvider<OnboardingCubit>(
          create: (_) => OnboardingCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Info Viewer',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
