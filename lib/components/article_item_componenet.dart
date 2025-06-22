import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quick_facture/models/article.dart';

class ArticleItemComponenet extends StatefulWidget {
  final Article article;
  final int index;
  final VoidCallback onRemove;
  final VoidCallback onUpdate;

  const ArticleItemComponenet({
    super.key,
    required this.article,
    required this.index,
    required this.onRemove,
    required this.onUpdate,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ArticleItemState createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItemComponenet> {
  late TextEditingController _descriptionController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.article.description,
    );
    _quantityController = TextEditingController(
      text: widget.article.quantity.toString(),
    );
    _priceController = TextEditingController(
      text: widget.article.unitPrice.toString(),
    );

    _descriptionController.addListener(_updateArticle);
    _quantityController.addListener(_updateArticle);
    _priceController.addListener(_updateArticle);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _updateArticle() {
    widget.article.description = _descriptionController.text;
    widget.article.quantity = double.tryParse(_quantityController.text) ?? 0.0;
    widget.article.unitPrice = double.tryParse(_priceController.text) ?? 0.0;
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Article ${widget.index + 1}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: widget.onRemove,
                ),
              ],
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description *',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'La description est requise';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantité *',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requis';
                      }
                      final num = double.tryParse(value);
                      if (num == null || num <= 0) {
                        return 'Invalide';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: InputDecoration(
                      labelText: 'Prix unitaire HT *',
                      border: OutlineInputBorder(),
                      suffixText: 'DA',
                    ),
                    keyboardType: TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Requis';
                      }
                      final num = double.tryParse(value);
                      if (num == null || num < 0) {
                        return 'Invalide';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total HT:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${widget.article.totalHT.toStringAsFixed(2)} DA',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}