import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/app_routing_bloc.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_state.dart';
import 'bloc/onboarding_bloc.dart';
import 'bloc/quote_bloc.dart';
import 'constants/constants.dart';
import 'data/auth_repository.dart';
import 'data/quote_repository.dart';
import 'firebase_options.dart';
import 'screens/dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'services/gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  GeminiService.initialize();

  await Firebase.initializeApp(
    options: _firebaseOptionsForPlatform(),
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const AuraQuoteApp());
}

FirebaseOptions _firebaseOptionsForPlatform() {
  if (kIsWeb) {
    return FirebaseOptions(
      apiKey: DefaultFirebaseOptions.web.apiKey,
      appId:
          dotenv.env['FIREBASE_WEB_ID'] ?? DefaultFirebaseOptions.web.appId,
      messagingSenderId: DefaultFirebaseOptions.web.messagingSenderId,
      projectId: DefaultFirebaseOptions.web.projectId,
      authDomain: DefaultFirebaseOptions.web.authDomain,
      storageBucket: DefaultFirebaseOptions.web.storageBucket,
      measurementId: DefaultFirebaseOptions.web.measurementId,
    );
  }
  switch (defaultTargetPlatform) {
    case TargetPlatform.android:
      return FirebaseOptions(
        apiKey: DefaultFirebaseOptions.android.apiKey,
        appId: dotenv.env['FIREBASE_ANDROID_ID'] ??
            DefaultFirebaseOptions.android.appId,
        messagingSenderId: DefaultFirebaseOptions.android.messagingSenderId,
        projectId: DefaultFirebaseOptions.android.projectId,
        storageBucket: DefaultFirebaseOptions.android.storageBucket,
      );
    case TargetPlatform.iOS:
      return FirebaseOptions(
        apiKey: DefaultFirebaseOptions.ios.apiKey,
        appId: dotenv.env['FIREBASE_IOS_ID'] ??
            DefaultFirebaseOptions.ios.appId,
        messagingSenderId: DefaultFirebaseOptions.ios.messagingSenderId,
        projectId: DefaultFirebaseOptions.ios.projectId,
        storageBucket: DefaultFirebaseOptions.ios.storageBucket,
        androidClientId: DefaultFirebaseOptions.ios.androidClientId,
        iosBundleId: DefaultFirebaseOptions.ios.iosBundleId,
      );
    default:
      throw UnsupportedError(
        'Firebase not configured for $defaultTargetPlatform',
      );
  }
}

class AuraQuoteApp extends StatelessWidget {
  const AuraQuoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider<QuoteBloc>(
          create: (_) => QuoteBloc(repository: QuoteRepository()),
        ),
        BlocProvider<OnboardingBloc>(
          create: (_) => OnboardingBloc(),
        ),
        BlocProvider<AppRoutingBloc>(
          create: (_) => AppRoutingBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'AuraQuote',
        debugShowCheckedModeBanner: false,
        theme: _buildTheme(),
        home: const _AppShell(),
      ),
    );
  }

  ThemeData _buildTheme() {
    final colorScheme = ColorScheme.dark(
      primary: AuraQuoteColors.primary,
      primaryContainer: AuraQuoteColors.primaryContainer,
      secondary: AuraQuoteColors.secondary,
      secondaryContainer: AuraQuoteColors.secondaryContainer,
      surface: AuraQuoteColors.surface,
      onPrimary: AuraQuoteColors.onPrimaryContainer,
      onPrimaryContainer: AuraQuoteColors.onPrimaryContainer,
      onSecondary: AuraQuoteColors.onSecondaryContainer,
      onSecondaryContainer: AuraQuoteColors.onSecondaryContainer,
      onSurface: AuraQuoteColors.onSurface,
      onSurfaceVariant: AuraQuoteColors.onSurfaceVariant,
      outline: AuraQuoteColors.outline,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AuraQuoteColors.background,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.montserratTextTheme().merge(
        GoogleFonts.playfairDisplayTextTheme(),
      ),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> {
  @override
  void initState() {
    super.initState();
    context.read<AppRoutingBloc>().add(AppStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppRoutingBloc, AppRoutingState>(
      builder: (context, state) {
        if (state is AppRoutingSplash) {
          return const SplashScreen();
        }
        if (state is AppRoutingOnboarding) {
          return OnboardingScreen(
            onComplete: () {
              context.read<AppRoutingBloc>().add(OnboardingFinished());
            },
          );
        }
        return BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is AuthSuccess) {
              return const DashboardScreen();
            }
            return const LoginScreen();
          },
        );
      },
    );
  }
}
