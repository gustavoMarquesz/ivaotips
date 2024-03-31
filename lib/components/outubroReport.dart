import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'package:intl/date_symbol_data_local.dart';
import 'package:ivaotips/components/transaction_list.dart';
import 'package:ivaotips/models/transactions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OutubroReport extends StatefulWidget {
  @override
   _OutubroReportState createState() => _OutubroReportState();
}

class  _OutubroReportState extends State<OutubroReport> {
  final List<Transaction> _transactions = [];
  
  double _bancaValue = 0.0;

  Future<void> _loadData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? transactionsJson = prefs.getStringList('transactions_out');
    final double? bancaValue = prefs.getDouble('bancaValue_out');

    if (transactionsJson != null) {
      setState(() {
        _transactions.clear();
        _transactions.addAll(transactionsJson.map((json) => Transaction.fromJson(jsonDecode(json))));
      });
    }

    if (bancaValue != null) {
      setState(() {
        _bancaValue = bancaValue;
      });
    }
  }

  Future<void> _saveData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> transactionsJson = _transactions.map((transaction) => jsonEncode(transaction.toJson())).toList();
    await prefs.setStringList('transactions_out', transactionsJson);

    await prefs.setDouble('bancaValue_out', _bancaValue);
  }
@override
  void initState() {
    initializeDateFormatting(); // Inicialize os dados de localização
    super.initState();
    _loadData(); // Carregar dados salvos ao iniciar a pag tlg
  }

  Future<void> _addTransaction() async {
    final newTransaction = await showDialog<Transaction>(
      context: context,
      builder: (BuildContext context) {
        String title = '';
        String valueText = '';
        double value = 0.0;
        bool isAdding = true;
        DateTime selectedDate = DateTime.now();

        return AlertDialog(
          title: Text('Nova Transação'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField(
                  value: isAdding ? 'Green' : 'Red',
                  items: ['Green', 'Red'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      isAdding = newValue == 'Green';
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Valor'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => valueText = value,
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    'Data: ${DateFormat('dd/MM/y', 'pt_BR').format(selectedDate)}', // Formatando a data
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (valueText.isNotEmpty) {
                  value = double.tryParse(valueText) ?? 0.0;

                  Navigator.of(context).pop(Transaction(
                    id: DateTime.now().toString(),
                    title: isAdding ? 'Green' : 'Red',
                    value: isAdding ? value : -value,
                    date: selectedDate,
                    valorTotalBanca: _bancaValue,
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Preencha todos os campos!'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );

    if (newTransaction != null) {
      setState(() {
        if (_transactions.length < 31) {
          _transactions.add(newTransaction);

          _bancaValue += newTransaction.value;
          _saveData(); // Save data after adding a transaction
        } else {
          // Handle transaction limit reached
        }
      });
    }
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    final greenTransactions = _transactions.where((t) => t.title == 'Green').toList();
    final redTransactions = _transactions.where((t) => t.title == 'Red').toList();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(level: 0, child: pw.Text('Ivaõ tips - direitos reservados')),
              pw.Paragraph(text: 'Lista de transações'),
              pw.Table.fromTextArray(
                context: context,
                data: [
                  ['Tipo', 'Valor', 'Data'],
                  for (var transaction in _transactions)
                    [
                      transaction.title == 'Green' ? 'Green' : 'Red',
                      transaction.value.toString(),
                      DateFormat('dd/MM/y', 'pt_BR').format(transaction.date), // Formatando a data
                    ],
                ],
              ),
              pw.Text('Valor Total Antes: ${_bancaValue - _transactions.map((t) => t.value).reduce((a, b) => a + b)}'),
              pw.Text('Valor Total Depois: $_bancaValue'),
              pw.Text('Quantidade de Transações Green: ${greenTransactions.length}'),
              pw.Text('Quantidade de Transações Red: ${redTransactions.length}'),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final filePath = "${output.path}/individual_report.pdf";
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    print("PDF saved to: $filePath");
    if (await file.exists()) {
      print("PDF EXISTE, ABRINDO");
      await OpenFile.open(filePath);
    } else {
      print("Rapaz encontrei não");
    }
  }

  void _removeTransaction(Transaction transactionToRemove) {
    setState(() {
      _transactions.remove(transactionToRemove);
      _bancaValue -= transactionToRemove.value;
      _saveData();
    });
  }

  void _editBancaValue() async {
    double? newBancaValue = await showDialog<double>(
      context: context,
      builder: (BuildContext context) {
        double bancaValue = _bancaValue;

        return AlertDialog(
          title: Text('Editar Valor da Banca'),
          content: TextFormField(
            initialValue: _bancaValue.toString(),
            decoration: InputDecoration(labelText: 'Novo Valor'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              bancaValue = double.tryParse(value) ?? _bancaValue;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(bancaValue);
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (newBancaValue != null) {
      setState(() {
        _bancaValue = newBancaValue;
        _saveData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Colors.green,
        ),
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Relatório mensal', // Alterado o título
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: _generatePDF,
              icon: Icon(Icons.picture_as_pdf),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              child: Image.asset(
                'assets/images/ballmoney.jpg',
                height: 250,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Transações de Outubro',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Banca: $_bancaValue',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Valor atual da Banca'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        _bancaValue = double.tryParse(value) ?? 0.0;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _bancaValue = 0.0;
                      });
                    },
                    child: Text('Zerar Banca'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _transactions.length,
                itemBuilder: (ctx, index) {
                  final transaction = _transactions[index];
                  return ListTile(
                    title: Text(transaction.title),
                    subtitle: Text('Valor: ${transaction.value.toString()}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Data: ${DateFormat('dd/MM/y', 'pt_BR').format(transaction.date)}'),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeTransaction(transaction),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: SizedBox(
          width: 35,
          height: 35,
          child: FloatingActionButton(
            onPressed: _addTransaction,
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

