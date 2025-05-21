import 'package:flutter/material.dart';
import '../database/health_database.dart';
import '../models/health_data_model.dart';

class HealthDataListPage extends StatefulWidget {
  const HealthDataListPage({super.key});

  @override
  State<HealthDataListPage> createState() => _HealthDataListPageState();
}

class _HealthDataListPageState extends State<HealthDataListPage> {
  late Future<List<HealthDataModel>> _healthDataList;

  @override
  void initState() {
    super.initState();
    _healthDataList = HealthDatabase.instance.getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('📊 Sağlık Verileri')),
      body: FutureBuilder<List<HealthDataModel>>(
        future: _healthDataList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Kayıtlı sağlık verisi bulunamadı.'));
          }

          final data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return ListTile(
                leading: const Icon(Icons.favorite, color: Colors.red),
                title: Text('${item.type}'),
                subtitle: Text('${item.date.toLocal()}'),
                trailing: Text('${item.value.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
    );
  }
}
