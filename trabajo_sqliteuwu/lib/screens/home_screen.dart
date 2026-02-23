import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../model/estudiante.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nombreCtrl = TextEditingController();
  final _edadCtrl = TextEditingController();
  List<Estudiante> _estudiantes = [];

  static const purple = Color(0xFF6C63FF);

  @override
  void initState() {
    super.initState();
    _cargarEstudiantes();
  }

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _edadCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarEstudiantes() async {
    final lista = await DbHelper.obtenerTodos();
    setState(() => _estudiantes = lista);
  }

  Future<void> _agregarEstudiante() async {
    if (_nombreCtrl.text.trim().isEmpty || _edadCtrl.text.trim().isEmpty) {
      _snack('⚠️ Completa todos los campos', isError: true);
      return;
    }
    final edad = int.tryParse(_edadCtrl.text.trim());
    if (edad == null || edad <= 0) {
      _snack('⚠️ Ingresa una edad válida', isError: true);
      return;
    }
    await DbHelper.insertar(
      Estudiante(nombre: _nombreCtrl.text.trim(), edad: edad),
    );
    _nombreCtrl.clear();
    _edadCtrl.clear();
    await _cargarEstudiantes();
    _snack('✅ Estudiante registrado');
  }

  Future<void> _eliminar(int id) async {
    await DbHelper.eliminar(id);
    await _cargarEstudiantes();
    _snack('🗑️ Estudiante eliminado');
  }

  void _mostrarDialogoEditar(Estudiante e) {
    final nombreEdit = TextEditingController(text: e.nombre);
    final edadEdit = TextEditingController(text: e.edad.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Editar estudiante',
          style: TextStyle(color: purple, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _inputField(nombreEdit, 'Nombre', Icons.person_outline),
            const SizedBox(height: 12),
            _inputField(
              edadEdit,
              'Edad',
              Icons.cake_outlined,
              tipo: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: purple),
            onPressed: () async {
              final edad = int.tryParse(edadEdit.text.trim());
              if (nombreEdit.text.trim().isEmpty || edad == null || edad <= 0) {
                _snack('⚠️ Datos inválidos', isError: true);
                return;
              }
              await DbHelper.actualizar(
                Estudiante(
                  id: e.id,
                  nombre: nombreEdit.text.trim(),
                  edad: edad,
                ),
              );
              Navigator.pop(context);
              await _cargarEstudiantes();
              _snack('✏️ Estudiante actualizado');
            },
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _snack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red.shade600 : purple,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        backgroundColor: purple,
        centerTitle: true,
        title: const Text(
          'Gestión de Estudiantes',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Formulario
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              children: [
                _inputField(
                  _nombreCtrl,
                  'Nombre del estudiante',
                  Icons.person_outline,
                ),
                const SizedBox(height: 12),
                _inputField(
                  _edadCtrl,
                  'Edad',
                  Icons.cake_outlined,
                  tipo: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _agregarEstudiante,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Registrar estudiante',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: purple,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Encabezado lista
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.school, color: purple, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Estudiantes registrados (${_estudiantes.length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF333366),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Lista
          Expanded(
            child: _estudiantes.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'No hay estudiantes registrados',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _estudiantes.length,
                    itemBuilder: (_, i) {
                      final e = _estudiantes[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: purple,
                            child: Text(
                              e.nombre[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            e.nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            '${e.edad} años',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: purple,
                                ),
                                onPressed: () => _mostrarDialogoEditar(e),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Colors.red.shade400,
                                ),
                                onPressed: () => _eliminar(e.id!),
                              ),
                            ],
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

  Widget _inputField(
    TextEditingController ctrl,
    String label,
    IconData icono, {
    TextInputType tipo = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: tipo,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icono, color: purple),
        filled: true,
        fillColor: const Color(0xFFF0EEFF),
        labelStyle: const TextStyle(color: purple),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: purple, width: 2),
        ),
      ),
    );
  }
}
