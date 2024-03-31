import 'package:flutter/material.dart';
import 'package:ivaotips/components/abrilReport.dart';
import 'package:ivaotips/components/agostoReport.dart';
import 'package:ivaotips/components/dezembroReport.dart';
import 'package:ivaotips/components/fevReport.dart';
import 'package:intl/intl.dart'; // Importe a biblioteca intl para formatação de datas
import 'package:intl/date_symbol_data_local.dart'; // Importe isso para inicializar os dados de localização
import 'package:ivaotips/components/janReport.dart';
import 'package:ivaotips/components/julhoReport.dart';
import 'package:ivaotips/components/junhoReport.dart';
import 'package:ivaotips/components/maioReport.dart';
import 'package:ivaotips/components/marcReport.dart';
import 'package:ivaotips/components/novembroReport.dart';
import 'package:ivaotips/components/outubroReport.dart';
import 'package:ivaotips/components/setembroReport.dart';

void main() {
  initializeDateFormatting();
  runApp(IvoApp());
}

class IvoApp extends StatefulWidget {
  @override
  _IvoAppState createState() => _IvoAppState();
}

class _IvoAppState extends State<IvoApp> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    CalculadoraUnidadesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calculate),
              label: 'Calcular Unidade',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> meses = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ivão Tips ⚽', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 280, // Altura da imagem
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/home.webp'),
                fit: BoxFit
                    .fitWidth, // Ajuste para ocupar toda a largura disponível
              ),
            ),
          ),
          SizedBox(height: 24.0), // Espaçamento entre a imagem e o título
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Bem-vindo!',
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
           SizedBox(height: 20.0), // Espaçamento entre a imagem e o título
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Aqui você controla sua gestão de banca 💰',
              style: TextStyle(
                fontSize: 13.0,
               
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10.0), // Espaçamento entre a imagem e os botões
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 2.0, // Ajuste conforme necessário
              ),
              itemCount: meses.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () {
                    _navigateToMonthPage(context, index);
                  },
                  child: Text(meses[index]),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToMonthPage(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JaneiroReport()),
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FevReport()),
        );
        break;
        case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MarcReport()),
        );
        break;
         case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AbrilReport()),
        );
        break;
         case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MaioReport()),
        );
        break;

         case 5:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JunhoReport()),
        );
        break;
         case 6:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JulhoReport()),
        );
        break;
         case 7:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AgostoReport()),
        );
        break;
         case 8:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SetembroReport()),
        );
        break;
         case 9:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OutubroReport()),
        );
        break;

         case 10:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NovReport()),
        );
        break;
         case 11:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DezReport()),
        );
        break;
    }
  }
}

class CalculadoraUnidadesPage extends StatefulWidget {
  @override
  _CalculadoraUnidadesPageState createState() =>
      _CalculadoraUnidadesPageState();
}

class _CalculadoraUnidadesPageState extends State<CalculadoraUnidadesPage> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculador de Unidade',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Image.asset(
            'assets/images/liver.webp',
            height: 250,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Qual valor da sua banca?',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 10.0),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Valor da Banca',
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    double? valorBanca = double.tryParse(_controller.text);
                    if (valorBanca != null) {
                      double unidadeConservadora = valorBanca / 100;
                      double unidadeMaoCheia = valorBanca / 50;
                      double unidadeAlavancagem = valorBanca / 20;
                      _mostrarResultado(unidadeConservadora, unidadeMaoCheia,
                          unidadeAlavancagem);
                    } else {
                      _mostrarAlerta('Erro',
                          'Por favor, insira um valor válido para a banca.');
                    }
                  },
                  child: Text('Calcular'),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    _mostrarPopupUnidadePersonalizada();
                  },
                  child: Text('Unidade Personalizada'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarResultado(double unidadeConservadora, double unidadeMaoCheia,
      double unidadeAlavancagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Resultados'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Unidade Conservadora: R\$ ${unidadeConservadora.toStringAsFixed(2)}'),
              Text(
                  'Unidade Intermediária: R\$ ${unidadeMaoCheia.toStringAsFixed(2)}'),
              Text(
                  'Unidade Alavancagem 🔥: R\$ ${unidadeAlavancagem.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAlerta(String titulo, String mensagem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(titulo),
          content: Text(mensagem),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarPopupUnidadePersonalizada() {
    double? valorBanca;
    double? valorDivisao;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Unidade Personalizada'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor da Banca',
                ),
                onChanged: (value) {
                  valorBanca = double.tryParse(value);
                },
              ),
              SizedBox(height: 10.0),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor personalizado',
                ),
                onChanged: (value) {
                  valorDivisao = double.tryParse(value);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (valorBanca != null &&
                    valorDivisao != null &&
                    valorDivisao! != 0) {
                  double resultado = valorBanca! / valorDivisao!;
                  _mostrarAlerta('Resultado',
                      'O valor da unidade é R\$ ${resultado.toStringAsFixed(2)}');
                } else {
                  _mostrarAlerta('Erro',
                      'Por favor, insira valores válidos para a banca e para a divisão.');
                }
              },
              child: Text('Calcular'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
