import 'package:flutter/material.dart';

void main() {
  runApp(MiApp());
}

class MiApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Formulario(),
    );
  }
}

class Formulario extends StatefulWidget {
  @override
  _FormularioState createState() => _FormularioState();
}

class _FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();
  
  TextEditingController nombre = TextEditingController();
  TextEditingController correo = TextEditingController();
  TextEditingController edad = TextEditingController();
  TextEditingController telefono = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulario'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nombre,
                decoration: InputDecoration(labelText: 'Nombre'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo vacío';
                  return null;
                },
              ),
              TextFormField(
                controller: correo,
                decoration: InputDecoration(labelText: 'Correo'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo vacío';
                  return null;
                },
              ),
              TextFormField(
                controller: edad,
                decoration: InputDecoration(labelText: 'Edad'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'Campo vacío';
                  if (int.tryParse(value) == null) return 'Solo números';
                  return null;
                },
              ),
              TextFormField(
                controller: telefono,
                decoration: InputDecoration(labelText: 'Teléfono'),
                validator: (value) {
                  if (value!.isEmpty) return 'Campo vacío';
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Visualizacion(
                          nombre: nombre.text,
                          correo: correo.text,
                          edad: edad.text,
                          telefono: telefono.text,
                        ),
                      ),
                    );
                  }
                },
                child: Text('Enviar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Visualizacion extends StatelessWidget {
  final String nombre;
  final String correo;
  final String edad;
  final String telefono;
  
  Visualizacion({
    required this.nombre,
    required this.correo,
    required this.edad,
    required this.telefono,
  });
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nombre: $nombre', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Correo: $correo', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Edad: $edad', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Teléfono: $telefono', style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Regresar'),
            ),
          ],
        ),
      ),
    );
  }
}