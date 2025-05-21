import 'package:health/health.dart';
import '../database/health_database.dart';
import '../models/health_data_model.dart';

class HealthService {
  final Health _health = Health();

  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.BLOOD_GLUCOSE,
  ];

  Future<bool> requestPermissions() async {
    print('🛂 İzin isteniyor...');
    final granted = await _health.requestAuthorization(_types);
    print('✅ İzin durumu: $granted');
    return granted;
  }

  Future<List<HealthDataPoint>> fetchHealthData() async {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    List<HealthDataPoint> healthData = [];

    try {
      healthData = await _health.getHealthDataFromTypes(
        startTime: yesterday,
        endTime: now,
        types: _types,
      );

      healthData = _health.removeDuplicates(healthData);

      for (var dataPoint in healthData) {
        final model = HealthDataModel(
          type: dataPoint.typeString,
          value: (dataPoint.value as num).toDouble(),
          date: dataPoint.dateFrom,
        );

        await HealthDatabase.instance.insertHealthData(model);
      }

    } catch (e) {
      print('HATA: Sağlık verileri alınamadı: $e');
    }

    return healthData;
  }
}
