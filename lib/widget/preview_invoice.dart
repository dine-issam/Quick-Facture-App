import 'package:flutter/material.dart';
import 'package:quick_facture/models/invoice.dart';

class InvoicePreview extends StatelessWidget {
  final Invoice invoice;

  const InvoicePreview({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Column(
                  children: [
                    Text(
                      'FACTURE',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'N° FAC-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32),

              // Client and Date Info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FACTURÉ À:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          invoice.clientName.isNotEmpty
                              ? invoice.clientName
                              : 'Nom du client',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          invoice.clientEmail.isNotEmpty
                              ? invoice.clientEmail
                              : 'email@client.com',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'DATE DE FACTURE:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${invoice.invoiceDate.day.toString().padLeft(2, '0')}/${invoice.invoiceDate.month.toString().padLeft(2, '0')}/${invoice.invoiceDate.year}',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 32),

              // Articles Table
              Text(
                'DÉTAIL DES PRESTATIONS',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 16),

              // Table Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Description',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        'Qté',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'P.U. HT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Total HT',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),

              // Table Rows
              ...invoice.articles
                  .where(
                    (article) =>
                        article.description.isNotEmpty ||
                        article.quantity > 0 ||
                        article.unitPrice > 0,
                  )
                  .map(
                    (article) => Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              article.description.isNotEmpty
                                  ? article.description
                                  : 'Article',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              article.quantity.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${article.unitPrice.toStringAsFixed(2)} DA',
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${article.totalHT.toStringAsFixed(2)} DA',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

              if (invoice.articles
                  .where(
                    (article) =>
                        article.description.isNotEmpty ||
                        article.quantity > 0 ||
                        article.unitPrice > 0,
                  )
                  .isEmpty)
                Container(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Text(
                      'Aucun article à afficher',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ),

              SizedBox(height: 24),

              // Totals
              Row(
                children: [
                  Spacer(),
                  SizedBox(
                    width: 250,
                    child: Column(
                      children: [
                        _buildSummaryRow(
                          'Total HT:',
                          '${invoice.totalHT.toStringAsFixed(2)} DA',
                        ),
                        SizedBox(height: 8),
                        _buildSummaryRow(
                          'TVA (20%):',
                          '${invoice.tva.toStringAsFixed(2)} DA',
                        ),
                        SizedBox(height: 8),
                        Divider(thickness: 2),
                        SizedBox(height: 8),
                        _buildSummaryRow(
                          'Total TTC:',
                          '${invoice.totalTTC.toStringAsFixed(2)} DA',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32),

              // Footer
              Center(
                child: Text(
                  'Merci pour votre confiance !',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}
