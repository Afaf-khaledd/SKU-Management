class BranchModel {
  final String? id;
  final String name;
  final String phone;
  final String managerName;
  final String location;

  BranchModel({
    this.id,
    required this.name,
    required this.phone,
    required this.managerName,
    required this.location,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json, String docId) {
    return BranchModel(
      id: docId,
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      managerName: json['managerName'] ?? '',
      location: json['location'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'managerName': managerName,
      'location': location,
    };
  }
}