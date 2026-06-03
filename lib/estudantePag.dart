import 'package:flutter/material.dart';
import 'package:db2026/estudante.dart';
import 'package:db2026/estudanteDAO.dart';

class EstudantePage extends StatefulWidget {
  const EstudantePage({super.key});

  @override
  State<EstudantePage> createState() => _EstudantePageState();
}

class _EstudantePageState extends State<EstudantePage> {
  final estudanteDAO dao = estudanteDAO();
  List<estudante> lista = [];

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    lista = await dao.getEstudante();
    setState(() {});
  }

  Future<void> eliminar(int id) async {
    await dao.deleteEstudante(id);
    carregarDados();
  }

  void irFormulario() {
    showDialog(
      context: context,
      builder: (context) {
        final nomeController = TextEditingController();
        final matriculaController = TextEditingController();

        return AlertDialog(
          title: const Text("Nuevo Estudiante"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: matriculaController,
                decoration: const InputDecoration(labelText: "Matrícula"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nomeController.text.isEmpty || matriculaController.text.isEmpty) return;

                final e = estudante(
                  nome: nomeController.text,
                  matricula: matriculaController.text,
                );

                await dao.addEstudante(e);
                Navigator.pop(context);
                carregarDados();
              },
              child: const Text("Guardar"),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Estudiantes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: irFormulario,
        child: const Icon(Icons.add),
      ),
      body: lista.isEmpty
          ? const Center(child: Text("No hay estudiantes registrados"))
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final e = lista[index];
                return ListTile(
                  title: Text(e.nome),
                  subtitle: Text(e.matricula),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => eliminar(e.id!),
                  ),
                );
              },
            ),
    );
  }
}