import 'package:flutter/material.dart';
import 'package:db2026/disciplina.dart';
import 'package:db2026/disciplinaDAO.dart';

class DisciplinaPage extends StatefulWidget {
  const DisciplinaPage({super.key});

  @override
  State<DisciplinaPage> createState() => _DisciplinaPageState();
}

class _DisciplinaPageState extends State<DisciplinaPage> {
  final disciplinaDAO dao = disciplinaDAO();
  List<Disciplina> lista = [];

  @override
  void initState() {
    super.initState();
    cargarDatos();
  }

  Future<void> cargarDatos() async {
    lista = await dao.getDisciplina();
    setState(() {});
  }

  void abrirFormulario() {
    final nomeController = TextEditingController();
    final profesorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Nueva Disciplina"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nomeController,
                decoration: const InputDecoration(labelText: "Nombre"),
              ),
              TextField(
                controller: profesorController,
                decoration: const InputDecoration(labelText: "Profesor"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (nomeController.text.isEmpty || profesorController.text.isEmpty) return;

                final d = Disciplina(
                  nome: nomeController.text,
                  profesor: profesorController.text,
                );

                await dao.addDisciplina(d);
                Navigator.pop(context);
                cargarDatos();
              },
              child: const Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> eliminar(int id) async {
    await dao.deleteDisciplina(id);
    cargarDatos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Disciplinas"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirFormulario,
        child: const Icon(Icons.add),
      ),
      body: lista.isEmpty
          ? const Center(child: Text("No hay disciplinas"))
          : ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, i) {
                final d = lista[i];
                return ListTile(
                  title: Text(d.nome),
                  subtitle: Text("Profesor: ${d.profesor}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      eliminar(d.id!);
                    },
                  ),
                );
              },
            ),
    );
  }
}