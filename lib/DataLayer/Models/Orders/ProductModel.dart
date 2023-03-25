class ProductModel {
  int? productCategoryId;
  String? productCategory;
  String? imageBlcok;
  List<Products>? products;

  ProductModel(
      {this.productCategoryId,
        this.productCategory,
        this.imageBlcok,
        this.products});

  ProductModel.fromJson(Map<String, dynamic> json) {
    productCategoryId = json['ProductCategoryId'];
    productCategory = json['ProductCategory'];
    imageBlcok = json['ImageBlcok'];
    if (json['Products'] != null) {
      products = <Products>[];
      json['Products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ProductCategoryId'] = this.productCategoryId;
    data['ProductCategory'] = this.productCategory;
    data['ImageBlcok'] = this.imageBlcok;
    if (this.products != null) {
      data['Products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  int? id;
  String? barcode;
  String? detail;
  String? name;
  String? productCategory;
  int? productCategoryId;
  double? saleRate;
  List<ImageItems>? imageItems;
  int counter = 0;

  Products(
      {this.id,
        this.barcode,
        this.detail,
        this.name,
        this.productCategory,
        this.productCategoryId,
        this.saleRate,
        this.imageItems});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['Id'];
    barcode = json['Barcode'];
    detail = json['Detail'];
    name = json['Name'];
    productCategory = json['ProductCategory'];
    productCategoryId = json['ProductCategoryId'];
    saleRate = json['SaleRate'];
    if (json['ImageItems'] != null) {
      imageItems = <ImageItems>[];
      json['ImageItems'].forEach((v) {
        imageItems!.add(new ImageItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Id'] = this.id;
    data['Barcode'] = this.barcode;
    data['Detail'] = this.detail;
    data['Name'] = this.name;
    data['ProductCategory'] = this.productCategory;
    data['ProductCategoryId'] = this.productCategoryId;
    data['SaleRate'] = this.saleRate;
    if (this.imageItems != null) {
      data['ImageItems'] = this.imageItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageItems {
  String? imageBlock;
  bool? isDefault;

  ImageItems({this.imageBlock, this.isDefault});

  ImageItems.fromJson(Map<String, dynamic> json) {
    imageBlock = json['ImageBlock'];
    isDefault = json['IsDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ImageBlock'] = this.imageBlock;
    data['IsDefault'] = this.isDefault;
    return data;
  }
}