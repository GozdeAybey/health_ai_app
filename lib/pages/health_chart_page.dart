import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../database/health_database.dart';
import '../models/health_data_model.dart';

class HealthChartPage extends StatefulWidget {
  const HealthChartPage({super.key});

  @override
  State<HealthChartPage> createState() => _HealthChartPageState();
}

class _HealthChartPageState extends State<HealthChartPage> {
  List<FlSpot> _dataPoints = [];

  @override
  void initState() {
    super.initState();
    _loadChartData();
  }

  Future<void> _loadChartData() async {
    final healthData = await HealthDatabase.instance.getAllData();

    // Örneğin sadece 'HEART_RATE' tipini al
    final filtered = healthData
        .where((d) => d.type == 'HEART_RATE')
        .toList();

    // Zamanı x ekseni olarak göster
    final List<FlSpot> points = [];
    for (int i = 0; i < filtered.length; i++) {
      points.add(FlSpot(i.toDouble(), filtered[i].value));
    }

    setState(() {
      _dataPoints = points;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📈 Kalp Atış Grafiği')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _dataPoints.isEmpty
            ? const Center(child: Text('Grafik verisi bulunamadı.'))
            : LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: _dataPoints,
                      isCurved: true,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                      color: Colors.red,
                    ),
                  ],
                  titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                ),
              ),
      ),
    );
  }
}
