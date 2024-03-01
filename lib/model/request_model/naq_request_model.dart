class NaqQuestionRequestModel {
  String? type;

  NaqQuestionRequestModel({this.type});

  NaqQuestionRequestModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    return data;
  }
}