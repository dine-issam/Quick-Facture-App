import 'package:quick_facture/models/article.dart';

class Invoice {
  String clientName;
  String clientEmail;
  DateTime invoiceDate;
  List<Article> articles;

  Invoice({
    this.clientName = '',
    this.clientEmail = '',
    DateTime? invoiceDate,
    List<Article>? articles,
  }) : invoiceDate = invoiceDate ?? DateTime.now(),
       articles = articles ?? [];

  double get totalHT =>
      articles.fold(0.0, (sum, article) => sum + article.totalHT);
  double get tva => totalHT * 0.20;
  double get totalTTC => totalHT + tva;
}