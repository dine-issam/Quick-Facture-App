import 'package:flutter/material.dart';
import 'package:quick_facture/models/article.dart';
import 'package:quick_facture/models/invoice.dart';
import 'package:quick_facture/widget/create_invoice.dart';
import 'package:quick_facture/widget/preview_invoice.dart';

class InvoiceScreen extends StatefulWidget {
  const InvoiceScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InvoiceScreenState createState() => _InvoiceScreenState();
}

class _InvoiceScreenState extends State<InvoiceScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Invoice invoice = Invoice();

  final _clientNameController = TextEditingController();
  final _clientEmailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // Add initial empty article

    // Listen to client info changes
    _clientNameController.addListener(() {
      setState(() {
        invoice.clientName = _clientNameController.text;
      });
    });

    _clientEmailController.addListener(() {
      setState(() {
        invoice.clientEmail = _clientEmailController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _clientNameController.dispose();
    _clientEmailController.dispose();
    super.dispose();
  }

  void _addArticle() {
    setState(() {
      invoice.articles.add(Article());
    });
  }

  void _removeArticle(int index) {
    if (invoice.articles.length > 1) {
      setState(() {
        invoice.articles.removeAt(index);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red[600],
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          content: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Au moins un article est requis',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          duration: Duration(seconds: 3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _updateArticle() {
    setState(() {
      // Trigger rebuild for calculations
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Module de Facturation'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.edit), text: 'Création'),
            Tab(icon: Icon(Icons.preview), text: 'Aperçu'),
          ],
          onTap: (index) {
            if (index == 1) {
             
              if (_formKey.currentState == null ||
                  !_formKey.currentState!.validate()) {
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red[600],
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    content: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.white),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Veuillez remplir correctement le formulaire avant de prévisualiser.',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    duration: Duration(seconds: 3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
               
                _tabController.animateTo(0);
                return;
              }
            }
            
            _tabController.animateTo(index);
          },
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(), // Prevent swipe to change tab
        children: [
          InvoiceForm(
            invoice: invoice,
            clientNameController: _clientNameController,
            clientEmailController: _clientEmailController,
            formKey: _formKey,
            onAddArticle: _addArticle,
            onRemoveArticle: _removeArticle,
            onUpdateArticle: _updateArticle,
          ),
          InvoicePreview(invoice: invoice),
        ],
      ),
    );
  }
}
