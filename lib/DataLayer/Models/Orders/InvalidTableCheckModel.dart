class InvalidTableCheckModel {
  String? validationRule;
  String? inputValue;
  String? vaildationMessage;

  InvalidTableCheckModel({this.validationRule, this.inputValue, this.vaildationMessage});

  InvalidTableCheckModel.fromJson(Map<String, dynamic> json) {
    validationRule = json['ValidationRule'];
    inputValue = json['InputValue'];
    vaildationMessage = json['VaildationMessage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ValidationRule'] = this.validationRule;
    data['InputValue'] = this.inputValue;
    data['VaildationMessage'] = this.vaildationMessage;
    return data;
  }
}