import 'package:flutter/material.dart';
import 'estudante.dart';
import 'disciplina.dart';
import 'cursando.dart';
import 'estudanteDAO.dart';
import 'disciplinaDAO.dart';
import 'cursandoDAO.dart';

class CursandoPage extends StatefulWidget {
  const CursandoPage({super.key});

  @override
  State<CursandoPage> createState() => _CursandoPageState();
}

class _CursandoPageState extends State<CursandoPage> {
  final estudanteDAO _estudanteDAO = estudanteDAO();
  final disciplinaDAO _disciplinaDAO = disciplinaDAO();
  final cursandoDAO _cursandoDAO = cursandoDAO();

  List<estudante> estudantes = [];
  List<Disciplina> disciplinas = [];
  List<Map<String, dynamic>> relatorio = [];

  estudante? selectedEstudante;
  Disciplina? selectedDisciplina;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  Future<void> carregarDados() async {
    estudantes = await _estudanteDAO.getEstudante();
    disciplinas = await _disciplinaDAO.getDisciplina();
    relatorio = await _cursandoDAO.getRelatorio();
    setState(() {});
  }

  Future<void> salvar() async {
    if (selectedEstudante == null || selectedDisciplina == null) return;

    final c = Cursando(
      estudanteId: selectedEstudante!.id!,
      disciplinaId: selectedDisciplina!.id!,
    );

    await _cursandoDAO.addCursando(c);

    setState(() {
      selectedEstudante = null;
      selectedDisciplina = null;
    });

    carregarDados();
  }

  Future<void> eliminar(int id) async {
    await _cursandoDAO.deleteCursando(id);
    carregarDados();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cursando (Relación)"),
      ),
      body: estudantes.isEmpty || disciplinas.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  "Primero debés registrar al menos un Estudiante y una Disciplina para realizar asignaciones.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            )
          : Column(
              children: [
                // FORMULARIO
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      // DROPDOWN ESTUDANTE
                      DropdownButton<estudante>(
                        value: selectedEstudante,
                        hint: const Text("Seleccionar estudiante"),
                        isExpanded: true,
                        items: estudantes.map((e) {
                          return DropdownMenuItem(
                            value: e,
                            child: Text(e.nome),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedEstudante = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      // DROPDOWN DISCIPLINA
                      DropdownButton<Disciplina>(
                        value: selectedDisciplina,
                        hint: const Text("Seleccionar disciplina"),
                        isExpanded: true,
                        items: disciplinas.map((d) {
                          return DropdownMenuItem(
                            value: d,
                            child: Text(d.nome),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedDisciplina = value;
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: salvar,
                        child: const Text("Asignar"),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // LISTA (REPORTE JOIN)
                Expanded(
                  child: relatorio.isEmpty
                      ? const Center(child: Text("No hay asignaciones registradas"))
                      : ListView.builder(
                          itemCount: relatorio.length,
                          itemBuilder: (context, i) {
                            final r = relatorio[i];
                            return ListTile(
                              title: Text(r['estudante'] ?? ''),
                              subtitle: Text(
                                "${r['disciplina'] ?? ''} - Prof: ${r['profesor'] ?? ''}",
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  eliminar(r['id']);
                                },
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}