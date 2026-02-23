import 'package:flutter/material.dart';
import '../model/recordatorio.dart';

// PANTALLA 4: Recordatorios completados
// Muestra solo los recordatorios marcados como hechos
class CompletadosScreen extends StatelessWidget {
  final List<Recordatorio> completados;

  const CompletadosScreen({super.key, required this.completados});

  @override
  Widget build(BuildContext context) {
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
          'Completados',
          style: TextStyle(
            color: Color(0xFF2D1B00),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: completados.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.hourglass_empty_rounded,
                    size: 64,
                    color: Color(0xFFBDA98A),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aún no has completado\nningún recordatorio',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF9C7B5A),
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: completados.length,
              itemBuilder: (_, i) {
                final r = completados[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFA5D6A7),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Color(0xFF4CAF50),
                        size: 26,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              r.texto,
                              style: const TextStyle(
                                color: Color(0xFF2D1B00),
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: Color(0xFF4CAF50),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              r.fecha,
                              style: const TextStyle(
                                color: Color(0xFF9C7B5A),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
