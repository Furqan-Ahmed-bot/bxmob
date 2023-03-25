// ignore_for_file: non_constant_identifier_names, unnecessary_this

class DealSave {
  int? ItemGroupId;
  String? barcode;
  String? ItemName;
  double? Quantity;
  String? ItemComment;

  DealSave(
      {this.ItemGroupId,
      this.barcode,
      this.Quantity,
      this.ItemComment,
      this.ItemName});

  DealSave.fromJson(Map<String, dynamic> json) {
    ItemGroupId = json['ItemGroupId'];
    barcode = json['Barcode'];
    ItemName = json['ItemName'];
    Quantity = json['Quantity'];
    ItemComment = json['ItemComment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ItemGroupId'] = this.ItemGroupId;
    data['Barcode'] = this.barcode;
    data['ItemName'] = this.ItemName;
    data['Quantity'] = this.Quantity;
    data['ItemComment'] = this.ItemComment;
    return data;
  }
}
