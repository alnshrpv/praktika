class Request {
  int id;
  String deviceType;
  String issueDescription;
  String status;

  Request({
    required this.id,
    required this.deviceType,
    required this.issueDescription,
    this.status = 'В ожидании',
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'deviceType': deviceType,
      'issueDescription': issueDescription,
      'status': status,
    };
  }

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      id: json['id'],
      deviceType: json['deviceType'],
      issueDescription: json['issueDescription'],
      status: json['status'],
    );
  }
}
