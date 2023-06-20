class ProductModel {
  int? id;
  String? nameProduct, price , qty,totalPrice ;

  ProductModel(
      {this.id,this.nameProduct,this.price,this.qty,this.totalPrice});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      nameProduct: json['name_product'],
      price: json['price'],
      qty: json['qty'],
      totalPrice: json['total_price'],
    );
  }
}
