class RegisterRequestModel {
  String? email;
  String? name;
  String? password;
  String? timeZone;

  RegisterRequestModel({this.email, this.name, this.password,this.timeZone});

  RegisterRequestModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    password = json['password'];
    timeZone = json['time_zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['password'] = password;
    data['time_zone'] = timeZone;
    return data;
  }
}