import 'package:flutter/material.dart';
import 'package:quick_facture/components/article_item_componenet.dart';
import 'package:quick_facture/components/total_card_component.dart';

import 'package:quick_facture/models/invoice.dart';

class InvoiceForm extends StatelessWidget {
  final Invoice invoice;
  final TextEditingController clientNameController;
  final TextEditingController clientEmailController;
  final GlobalKey<FormState> formKey;
  final VoidCallback onAddArticle;
  final Function(int) onRemoveArticle;
  final VoidCallback onUpdateArticle;

  const InvoiceForm({
    super.key,
    required this.invoice,
    required this.clientNameController,
    required this.clientEmailController,
    required this.formKey,
    required this.onAddArticle,
    required this.onRemoveArticle,
    required this.onUpdateArticle,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Client Information Section
            Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Informations Client',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: clientNameController,
                      decoration: InputDecoration(
                        labelText: 'Nom du client *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Le nom du client est requis';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: clientEmailController,
                      decoration: InputDecoration(
                        labelText: 'Email du client *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'L\'email du client est requis';
                        }
                        if (!RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        ).hasMatch(value)) {
                          return 'Format d\'email invalide';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: invoice.invoiceDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (date != null) {
                          invoice.invoiceDate = date;
                          onUpdateArticle();
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(width: 12),
                            Text(
                              'Date: ${invoice.invoiceDate.day}/${invoice.invoiceDate.month}/${invoice.invoiceDate.year}',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        
            SizedBox(height: 20),
        
            // Articles Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Articles',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  onPressed: onAddArticle,
                  icon: Icon(Icons.add),
                  label: Text('Ajouter'),
                ),
              ],
            ),
        
            SizedBox(height: 16),
        
            // Articles List
            if (invoice.articles.isEmpty)
              Card(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Aucun article ajouté',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              ...invoice.articles.asMap().entries.map(
                (entry) => ArticleItemComponenet(
              
                  article: entry.value,
                  index: entry.key,
                  onRemove: () => onRemoveArticle(entry.key),
                  onUpdate: onUpdateArticle,
                ),
              ),
        
            SizedBox(height: 20),
        
            // Totals Section
            TotalsCardComponents(invoice: invoice),
          ],
        ),
      ),
    );
  }
}