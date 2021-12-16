class EatModel {
  int? id;
  DateTime? eatDate;
  String? pillName;
  bool? completed;
  int? time;

  EatModel({this.eatDate, this.pillName, this.completed, int? time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'eatDate': eatDate,
      'pillName': pillName,
      'completed': completed,
      'time': time,
    };
  }
}
