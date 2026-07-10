import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_screen.dart';
import 'services/portfolio_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PortfolioTrackerApp());
}

/// Root widget for the minimalist Portfolio Tracker app.
class PortfolioTrackerApp extends StatelessWidget {
  const PortfolioTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PortfolioService()),
      ],
      child: MaterialApp(
        title: 'Portfolio Tracker',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF111827),
            surface: Colors.white,
            onSurface: const Color(0xFF111827),
          ),
          textTheme: GoogleFonts.interTextTheme(
            Theme.of(context).textTheme,
          ).apply(
            bodyColor: const Color(0xFF111827),
            displayColor: const Color(0xFF111827),
          ),
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
