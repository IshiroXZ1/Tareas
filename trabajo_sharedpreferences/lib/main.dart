import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: ProfileScreen()),
);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String _savedName = '';
  String _savedEmail = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('name') ?? '';
      _savedEmail = prefs.getString('email') ?? '';
      _nameController.text = _savedName;
      _emailController.text = _savedEmail;
    });
  }

  Future<void> _saveData() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Completa todos los campos')),
      );
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text.trim());
    await prefs.setString('email', _emailController.text.trim());
    setState(() {
      _savedName = _nameController.text.trim();
      _savedEmail = _emailController.text.trim();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('✅ Perfil guardado')));
  }

  @override
  Widget build(BuildContext context) {
    const purple = Color(0xFF6C63FF);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F4FF),
      appBar: AppBar(
        backgroundColor: purple,
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Avatar
            const CircleAvatar(
              radius: 48,
              backgroundColor: purple,
              child: Icon(Icons.person, size: 50, color: Colors.white),
            ),
            const SizedBox(height: 28),

            // Formulario
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _campo(_nameController, 'Nombre', Icons.person_outline),
                    const SizedBox(height: 14),
                    _campo(
                      _emailController,
                      'Correo electrónico',
                      Icons.email_outlined,
                      tipo: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _saveData,
                        icon: const Icon(Icons.save, color: Colors.white),
                        label: const Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
            ),

            // Datos guardados
            if (_savedName.isNotEmpty) ...[
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '✅ Datos guardados',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: purple,
                        ),
                      ),
                      const Divider(height: 20),
                      _fila(Icons.person, 'Nombre', _savedName),
                      const SizedBox(height: 10),
                      _fila(Icons.email, 'Correo', _savedEmail),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _campo(
    TextEditingController ctrl,
    String label,
    IconData icono, {
    TextInputType tipo = TextInputType.text,
  }) {
    const purple = Color(0xFF6C63FF);
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

  Widget _fila(IconData icono, String label, String valor) {
    return Row(
      children: [
        Icon(icono, color: const Color(0xFF6C63FF), size: 20),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Text(
              valor,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ],
    );
  }
}
