class Article {
   String description;
  double quantity;
  double unitPrice;

  Article({this.description = ''  , this.quantity = 1.0, this.unitPrice = 0.0});

  double get totalHT => quantity * unitPrice;
}