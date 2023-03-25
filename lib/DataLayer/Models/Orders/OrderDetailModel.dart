class OrderDetailModel {
  int? saleInvoiceItemId;
  int? productItemId;
  String? barcode;
  String? longName;
  double? saleRate;
  double? quantity;
  int? productUnitTypeId;
  String? unitType;
  int? itemStatus;
  int? parentId;
  String? description1;
  String? imageBlock;

  OrderDetailModel(
      {this.saleInvoiceItemId,
        this.productItemId,
        this.barcode,
        this.longName,
        this.saleRate,
        this.quantity,
        this.productUnitTypeId,
        this.unitType,
        this.itemStatus,
        this.parentId,
        this.description1,
        this.imageBlock,
        });

  OrderDetailModel.fromJson(Map<String, dynamic> json) {
    saleInvoiceItemId = json['SaleInvoiceItemId'];
    productItemId = json['ProductItemId'];
    barcode = json['Barcode'];
    longName = json['LongName'];
    saleRate = json['SaleRate'];
    quantity = json['Quantity'];
    productUnitTypeId = json['ProductUnitTypeId'];
    unitType = json['UnitType'];
    itemStatus = json['ItemStatus'];
    parentId = json['ParentId'];
    description1 = json['Description1'];
    imageBlock = json['ImageBlock'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['SaleInvoiceItemId'] = this.saleInvoiceItemId;
    data['ProductItemId'] = this.productItemId;
    data['Barcode'] = this.barcode;
    data['LongName'] = this.longName;
    data['SaleRate'] = this.saleRate;
    data['Quantity'] = this.quantity;
    data['ProductUnitTypeId'] = this.productUnitTypeId;
    data['UnitType'] = this.unitType;
    data['ItemStatus'] = this.itemStatus;
    data['ParentId'] = this.parentId;
    data['Description1'] = this.description1;
    data['ImageBlock'] = this.imageBlock;
    return data;
  }
}