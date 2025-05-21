class HealthDataModel {
  final int? id;
  final String type;
  final double value;
  final DateTime date;

  HealthDataModel({
    this.id,
    required this.type,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'value': value,
      'date': date.toIso8601String(),
    };
  }

  factory HealthDataModel.fromMap(Map<String, dynamic> map) {
    return HealthDataModel(
      id: map['id'],
      type: map['type'],
      value: map['value'],
      date: DateTime.parse(map['date']),
    );
  }
}
