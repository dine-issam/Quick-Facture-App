import 'package:flutter/material.dart';
import 'package:quick_facture/models/invoice.dart';

class TotalsCardComponents extends StatelessWidget {
  final Invoice invoice;

  const TotalsCardComponents({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Récapitulatif',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Divider(),
            SizedBox(height: 8),
            _buildTotalRow(
              'Total HT:',
              '${invoice.totalHT.toStringAsFixed(2)} DA',
            ),
            SizedBox(height: 8),
            _buildTotalRow('TVA (20%):', '${invoice.tva.toStringAsFixed(2)} DA'),
            SizedBox(height: 8),
            Divider(thickness: 2),
            SizedBox(height: 8),
            _buildTotalRow(
              'Total TTC:',
              '${invoice.totalTTC.toStringAsFixed(2)} DA',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 18 : 16,
            fontWeight: FontWeight.bold,
            color: isTotal ? Colors.green : null,
          ),
        ),
      ],
    );
  }
}