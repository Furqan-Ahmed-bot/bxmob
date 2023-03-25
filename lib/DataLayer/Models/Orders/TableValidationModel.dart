class TableValidationModel {
  String? validationRule;
  String? inputValue;
  String? vaildationMessage;

  TableValidationModel({this.validationRule, this.inputValue, this.vaildationMessage});

  TableValidationModel.fromJson(Map<String, dynamic> json) {
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
  // int? saleInvoiceId;
  // String? invoiceDate;
  // int? reservationId;
  // int? diningTableId;
  // int? salesmanId;
  //
  // TableValidationModel(
  //     {this.saleInvoiceId,
  //       this.invoiceDate,
  //       this.reservationId,
  //       this.diningTableId,
  //       this.salesmanId});
  //
  // TableValidationModel.fromJson(Map<String, dynamic> json) {
  //   saleInvoiceId = json['SaleInvoiceId'];
  //   invoiceDate = json['InvoiceDate'];
  //   reservationId = json['ReservationId'];
  //   diningTableId = json['DiningTableId'];
  //   salesmanId = json['SalesmanId'];
  // }
  //
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['SaleInvoiceId'] = this.saleInvoiceId;
  //   data['InvoiceDate'] = this.invoiceDate;
  //   data['ReservationId'] = this.reservationId;
  //   data['DiningTableId'] = this.diningTableId;
  //   data['SalesmanId'] = this.salesmanId;
  //   return data;
  // }
}