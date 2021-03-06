import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:studiomallia/database/app_database.dart';
import 'package:studiomallia/database/dao/clientes_dao.dart';
import 'package:studiomallia/main.dart';
import 'package:studiomallia/models/clientes.dart';
import 'package:studiomallia/view/cadastrar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studiomallia/view/menuprincipal.dart';



class TelaCliente extends StatefulWidget {
  @override
  _TelaClienteListState createState() => _TelaClienteListState();
}

class _TelaClienteListState extends State<TelaCliente> {


  @override
  Widget build(BuildContext context) {
    final ClientesDao _dao = ClientesDao();
    return Scaffold(
      appBar: AppBar(
        title: Text('Clientes'),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Cadastrar()));
        },
        child: Icon(Icons.add),
      ),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RaisedButton(
                        color: Colors.pink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        onPressed: () {
                         showAlertDialog2(context);
                        },
                        child: Row(
                          children: <Widget>[
                            Text(
                              "Remover Cliente",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        )
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
  final ClientesDao _dao = ClientesDao();
  showAlertDialog2(BuildContext context) {

//    Widget cancelaButton = FlatButton(
//      child: Text("Cancelar"),
//      onPressed:  () {
//        Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
//            builder: (BuildContext context) => TelaCliente()));
//      },
//    );
    Widget continuaButton = FlatButton(
      child: Text("Excluir"),
      onPressed:  () {
        final int id = widget.clientes.id;
        final String name = widget.clientes.nome;
        final String cpf = widget.clientes.cpf;
        final String datanascimento =
            widget.clientes.datanascimento;
        final String telefone = widget.clientes.telefone;
        final String rua = widget.clientes.rua;
        final String cidade = widget.clientes.cidade;
        final String estado = widget.clientes.estado;

        final Clientes newClientes = Clientes(id, name, cpf,
            datanascimento, telefone, rua, cidade, estado);
        _dao.deleteCustomer(id)
            .then((id) => Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
          builder: (BuildContext context) => menuprincipal())));
        print(newClientes);

      },

    );
    //configura o AlertDialog
    AlertDialog alert = AlertDialog(

      title: Text("Atenção!"),
      content: Text("Deseja excluir este cliente ?"),
      actions: [
        continuaButton,
      ],
    );
    //exibe o diálogo
    showDialog(

      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}