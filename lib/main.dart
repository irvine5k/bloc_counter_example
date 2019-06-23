import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:bloc_pattern/bloc_pattern.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Bloc _bloc;

  // Instanciando nosso bloc
  @override
  void initState() {
    _bloc = Bloc();
    super.initState();
  }

  // Dando dispose no nosso bloc
  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Você apertou esse botão:',
            ),
            StreamBuilder<int>(
                stream: _bloc.saida,
                builder: (context, snapshot) {
                  return Text(
                    '${snapshot.data} vezes',
                    style: Theme.of(context).textTheme.display1,
                  );
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bloc.aumentar,
        tooltip: 'Aumente',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Bloc extends BlocBase {
  // DECLARAMOS NOSSO CONTROLADOR DO FLUXO QUE SERÁ DO TIPO INTEIRO
  // E COMEÇARÁ COM ZERO
  final controlador = BehaviorSubject<int>.seeded(0);

  // DECLARAMOS NOSSA SAÍDA DE DADOS DO TIPO INTEIRO
  Observable<int> get saida => controlador.stream;

  // DECLARAMOS NOSSA ENTRADA DE DADOS DO TIPO INTEIRO
  Sink<int> get entrada => controlador.sink;

  // DECLARAMOS UM GETTER PARA RETORNAR O VALOR ATUAL DO NOSSO FLUXO
  int get valor => controlador.value;

  // CRIAMOS UMA FUNÇÃO PARA AUMENTAR O NOSSO CONTADOR.
  aumentar() {
    entrada.add(valor + 1);
  }

  // DAREMOS DISPOSE NO NOSSO CONTROLADOR, OU SEJA, FECHAREMOS ESSE CONTROLADOR.
  @override
  void dispose() {
    controlador.close();
    super.dispose();
  }
}
