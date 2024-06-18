import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../Modelos/Peaje.dart'; // Asegúrate de importar el modelo Peaje correctamente
import 'registrar.dart';
import 'Editar.dart'; // Asegúrate de importar la pantalla de edición correctamente

class Peajes extends StatefulWidget {
  @override
  _PeajesState createState() => _PeajesState();
}

class _PeajesState extends State<Peajes> {
  late Future<List<Peaje>> futurePeajes;

  @override
  void initState() {
    super.initState();
    futurePeajes = fetchPeajes();
  }

  Future<List<Peaje>> fetchPeajes() async {
    final response = await http.get(Uri.parse('http://localhost:5013/api/peaje'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((peaje) => Peaje.fromJson(peaje)).toList();
    } else {
      throw Exception('Failed to load peajes');
    }
  }

  Future<void> deletePeaje(int id) async {
    final response = await http.delete(Uri.parse('http://localhost:5013/api/peaje/$id'));

    if (response.statusCode == 200) {
      setState(() {
        futurePeajes = fetchPeajes();
      });
    } else {
      throw Exception('Failed to delete peaje');
    }
  }

  void confirmDelete(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación'),
          content: Text('¿Estás seguro de que quieres eliminar este peaje?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                deletePeaje(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editarPeaje(BuildContext context, Peaje peaje) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Editar(peaje),
      ),
    ).then((value) {
      if (value == true) {
        setState(() {
          futurePeajes = fetchPeajes();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Peajes'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PeajeForm(),
                ),
              ).then((value) {
                if (value == true) {
                  setState(() {
                    futurePeajes = fetchPeajes();
                  });
                }
              });
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder<List<Peaje>>(
          future: futurePeajes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Text("No hay peajes disponibles");
            } else {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const <DataColumn>[
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Placa')),
                    DataColumn(label: Text('Nombre Peaje')),
                    DataColumn(label: Text('Categoría')),
                    DataColumn(label: Text('Fecha')),
                    DataColumn(label: Text('Valor')),
                    DataColumn(label: Text('Acciones')),
                  ],
                  rows: snapshot.data!
                      .map((peaje) => DataRow(cells: [
                            DataCell(Text(peaje.id.toString())),
                            DataCell(Text(peaje.placa)),
                            DataCell(Text(peaje.nombrePeaje)),
                            DataCell(Text(peaje.categoriaTarifaId)),
                            DataCell(Text(peaje.fechaRegistro.toString())),
                            DataCell(Text(peaje.valor.toString())),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editarPeaje(context, peaje),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () {
                                    confirmDelete(context, peaje.id);
                                  },
                                ),
                              ],
                            )),
                          ]))
                      .toList(),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
