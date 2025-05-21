import 'package:flutter/material.dart';
import 'services/health_service.dart';
import 'pages/health_data_list_page.dart';
import 'pages/health_chart_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final healthService = HealthService();
  final granted = await healthService.requestPermissions();

  if (granted) {
    final data = await healthService.fetchHealthData();
    print('📊 Alınan sağlık verisi sayısı: ${data.length}');
  } else {
    print('❌ Sağlık verisi izinleri reddedildi.');
    
  }

  runApp(const HealthApp());
}

class HealthApp extends StatelessWidget {
  const HealthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health AI App',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/': (context) => const MyApp(), // 👈 MyApp yerine HomePage
        '/list': (context) => const HealthDataListPage(),
        '/chart': (context) => const HealthChartPage(),
      },
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // 👈 Sınıf adı da düzeltildi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏥 Sağlık AI Uygulaması')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/list');
              },
              icon: const Icon(Icons.list),
              label: const Text('Verileri Görüntüle'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/chart');
              },
              icon: const Icon(Icons.show_chart),
              label: const Text('Grafiği Göster'),
            ),
          ],
        ),
      ),
    );
  }
}
