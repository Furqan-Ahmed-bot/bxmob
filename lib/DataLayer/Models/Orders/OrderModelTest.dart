class OrderModelTest {
  String? Barcode;
  double? Quantity;
  double? Price;
  String? ItemComment;

  OrderModelTest({this.Barcode, this.Quantity, this.Price, this.ItemComment});

  OrderModelTest.fromJson(Map<String, dynamic> json) {
    Barcode = json['Barcode'];
    Quantity = json['Quantity'];
    Price = json['Price'];
    ItemComment = json['ItemComment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Barcode'] = this.Barcode;
    data['Quantity'] = this.Quantity;
    data['Price'] = this.Price;
    data['ItemComment'] = this.ItemComment;
    return data;
  }
}