import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';  // Importa el paquete de geolocalización

class Option2Screen extends StatefulWidget {
  @override
  _Option2ScreenState createState() => _Option2ScreenState();
}

class _Option2ScreenState extends State<Option2Screen> {
  String _locationMessage = '';  // Variable para almacenar el mensaje de ubicación

  @override
  void initState() {
    super.initState();
    _getLocation();  // Obtener la ubicación al iniciar la pantalla
  }

  // Método para obtener la ubicación actual
  void _getLocation() async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _locationMessage = 'Latitud: ${position.latitude}, Longitud: ${position.longitude}';
    });
  }

  // Método para abrir la cámara y capturar una imagen
  Future<void> _takePicture() async {
    // Aquí deberías implementar la lógica para abrir la cámara y capturar una imagen
    // Por ejemplo, utilizando el paquete image_picker: https://pub.dev/packages/image_picker
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocalizacion'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _takePicture();  // Llama al método para abrir la cámara al presionar el botón
              },
              child: Text('Tomar Foto'),
            ),
            SizedBox(height: 20),
            Text(
              'Mensaje de ubicación:',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              _locationMessage,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
