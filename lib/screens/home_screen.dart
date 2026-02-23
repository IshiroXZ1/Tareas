import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/recordatorio.dart';
import 'agregar_screen.dart';
import 'completados_screen.dart';

// PANTALLA 2: Home - Pantalla principal
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Recordatorio> _recordatorios = [];
  static const _key = 'recordatorios';

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List lista = jsonDecode(jsonString);
      setState(() {
        _recordatorios = lista.map((e) => Recordatorio.fromMap(e)).toList();
      });
    }
  }

  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(
      _recordatorios.map((e) => e.toMap()).toList(),
    );
    await prefs.setString(_key, jsonString);
  }

  Future<void> _navegarAgregar() async {
    final resultado = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const AgregarScreen()),
    );
    if (resultado != null) {
      final nuevo = Recordatorio(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        texto: resultado,
        completado: false,
        fecha: _fechaHoy(),
      );
      setState(() => _recordatorios.insert(0, nuevo));
      await _guardarDatos();
    }
  }

  Future<void> _toggleCompletar(String id) async {
    setState(() {
      _recordatorios = _recordatorios.map((r) {
        if (r.id == id) return r.copyWith(completado: !r.completado);
        return r;
      }).toList();
    });
    await _guardarDatos();
  }

  Future<void> _eliminar(String id) async {
    setState(() => _recordatorios.removeWhere((r) => r.id == id));
    await _guardarDatos();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Recordatorio eliminado'),
        backgroundColor: Colors.red.shade400,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _fechaHoy() {
    final now = DateTime.now();
    return '${now.day}/${now.month}/${now.year}';
  }

  List<Recordatorio> get _pendientes =>
      _recordatorios.where((r) => !r.completado).toList();

  List<Recordatorio> get _completados =>
      _recordatorios.where((r) => r.completado).toList();

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF8C42);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Mi Recordatorio',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2D1B00),
                        ),
                      ),
                      Text(
                        '${_pendientes.length} pendiente(s) hoy',
                        style: const TextStyle(
                          color: Color(0xFF9C7B5A),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            CompletadosScreen(completados: _completados),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFFA5D6A7),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.check_circle_outline_rounded,
                            color: Color(0xFF4CAF50),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${_completados.length} hechos',
                            style: const TextStyle(
                              color: Color(0xFF4CAF50),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_recordatorios.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: _completados.length / _recordatorios.length,
                        backgroundColor: const Color(0xFFE0C9B0),
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF4CAF50),
                        ),
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${(_completados.length / _recordatorios.length * 100).toInt()}% completado',
                      style: const TextStyle(
                        color: Color(0xFF9C7B5A),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Expanded(
              child: _pendientes.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              color: orange.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.celebration_rounded,
                              size: 45,
                              color: orange,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            '¡Todo al día! 🎉',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF2D1B00),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Agrega un nuevo recordatorio\npresionando el botón +',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF9C7B5A),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: _pendientes.length,
                      itemBuilder: (_, i) {
                        final r = _pendientes[i];
                        return _TarjetaRecordatorio(
                          recordatorio: r,
                          onCompletar: () => _toggleCompletar(r.id),
                          onEliminar: () => _eliminar(r.id),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navegarAgregar,
        backgroundColor: orange,
        elevation: 8,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Agregar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _TarjetaRecordatorio extends StatelessWidget {
  final Recordatorio recordatorio;
  final VoidCallback onCompletar;
  final VoidCallback onEliminar;

  const _TarjetaRecordatorio({
    required this.recordatorio,
    required this.onCompletar,
    required this.onEliminar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C42).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: GestureDetector(
          onTap: onCompletar,
          child: Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFF8C42), width: 2.5),
            ),
          ),
        ),
        title: Text(
          recordatorio.texto,
          style: const TextStyle(
            color: Color(0xFF2D1B00),
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 1.4,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            recordatorio.fecha,
            style: const TextStyle(color: Color(0xFF9C7B5A), fontSize: 12),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: Colors.red.shade300,
            size: 22,
          ),
          onPressed: onEliminar,
        ),
      ),
    );
  }
}
