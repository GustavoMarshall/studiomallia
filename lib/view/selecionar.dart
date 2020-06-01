import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studiomallia/database/app_database.dart';
import 'package:studiomallia/database/dao/clientes_dao.dart';
import 'package:studiomallia/main.dart';
import 'package:studiomallia/models/clientes.dart';
import 'package:studiomallia/view/cadastrar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelecionarCliente extends StatefulWidget {
  @override
  _SelecionarClienteListState createState() => _SelecionarClienteListState();
}

class _SelecionarClienteListState extends State<SelecionarCliente> {
  final ClientesDao _dao = ClientesDao();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecionar Cliente'),
        backgroundColor: Colors.pink,
      ),
      body: SafeArea(
          child: FutureBuilder<List<Clientes>>(
            initialData: List(),
            future: _dao.findAll(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  break;
                case ConnectionState.waiting:
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        Text('Carregando')
                      ],
                    ),
                  );
                  break;
                case ConnectionState.active:
                  break;
                case ConnectionState.done:
                  final List<Clientes> cliente = snapshot.data;
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      final Clientes clientes = cliente[index];
                      return _ClientesItem(clientes: clientes);
                    },
                    itemCount: cliente.length,
                  );
                  break;
              }

              return Container();
            },
          )),
    );
  }
}

class _ClientesItem extends StatefulWidget {
  final Clientes clientes;

  const _ClientesItem({Key key, this.clientes}) : super(key: key);

  @override
  __ClientesItemState createState() => __ClientesItemState();
}

class __ClientesItemState extends State<_ClientesItem> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ExpansionTile(

      title: Text(
        widget.clientes.nome,
        style: GoogleFonts.ptSans(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      subtitle: Text('Telefone: ${widget.clientes.telefone}'),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 16),
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'CPF: ${widget.clientes.cpf}',
                  textAlign: TextAlign.left,
                ),
                Text('Data de Nascimento: ${widget.clientes.datanascimento}'),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text('Endereço: Rua/Av: ${widget.clientes.rua} - '
                      'Cidade: ${widget.clientes.cidade} - '
                      'Estado: ${widget.clientes.estado}'),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context, widget.clientes.nome );
                  },
                  child: Text('Selecionar cliente'),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
