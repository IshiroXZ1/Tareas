import 'package:flutter/material.dart';

class AgregarScreen extends StatefulWidget {
  const AgregarScreen({super.key});
  @override
  State<AgregarScreen> createState() => _AgregarScreenState();
}

class _AgregarScreenState extends State<AgregarScreen> {
  final _ctrl = TextEditingController();
  String _categoriaSeleccionada = '📚 Estudio';

  // Categorías predefinidas
  final List<String> _categorias = [
    '📚 Estudio',
    '💊 Salud',
    '🏠 Casa',
    '💼 Trabajo',
    '🎯 Personal',
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _guardar() {
    if (_ctrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('⚠️ Escribe un recordatorio'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    Navigator.pop(context, '$_categoriaSeleccionada: ${_ctrl.text.trim()}');
  }

  @override
  Widget build(BuildContext context) {
    const orange = Color(0xFFFF8C42);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF2D1B00),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nuevo recordatorio',
          style: TextStyle(
            color: Color(0xFF2D1B00),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selección de categoría
            const Text(
              'Categoría',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xFF2D1B00),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _categorias.map((cat) {
                final seleccionado = cat == _categoriaSeleccionada;
                return GestureDetector(
                  onTap: () => setState(() => _categoriaSeleccionada = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: seleccionado ? orange : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: seleccionado ? orange : const Color(0xFFE0C9B0),
                        width: 1.5,
                      ),
                      boxShadow: seleccionado
                          ? [
                              BoxShadow(
                                color: orange.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: seleccionado
                            ? Colors.white
                            : const Color(0xFF9C7B5A),
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Campo de texto
            const Text(
              '¿Qué debes recordar?',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Color(0xFF2D1B00),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _ctrl,
              maxLines: 5,
              autofocus: true,
              style: const TextStyle(
                color: Color(0xFF2D1B00),
                fontSize: 16,
                height: 1.5,
              ),
              decoration: InputDecoration(
                hintText: 'Ej: Dejar la carrera de ingenieria :v',
                hintStyle: const TextStyle(color: Color(0xFFBDA98A)),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0C9B0),
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(
                    color: Color(0xFFE0C9B0),
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: const BorderSide(color: orange, width: 2),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),

            const Spacer(),

            // Botón guardar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _guardar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  elevation: 6,
                  shadowColor: orange.withOpacity(0.5),
                ),
                child: const Text(
                  'Guardar recordatorio',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
