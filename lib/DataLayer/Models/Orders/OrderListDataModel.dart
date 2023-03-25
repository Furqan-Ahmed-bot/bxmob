class OrderListDataModel {
  int? saleInvoiceId;
  String? invoiceDate;
  int? tokenNumber;
  String? tableName;
  double? netAmount;

  OrderListDataModel(
      {this.saleInvoiceId,
        this.invoiceDate,
        this.tokenNumber,
        this.tableName,
        this.netAmount});

  OrderListDataModel.fromJson(Map<String, dynamic> json) {
    saleInvoiceId = json['SaleInvoiceId'];
    invoiceDate = json['InvoiceDate'];
    tokenNumber = json['TokenNumber'];
    tableName = json['TableName'];
    netAmount = json['NetAmount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SaleInvoiceId'] = this.saleInvoiceId;
    data['InvoiceDate'] = this.invoiceDate;
    data['TokenNumber'] = this.tokenNumber;
    data['TableName'] = this.tableName;
    data['NetAmount'] = this.netAmount;
    return data;
  }
}