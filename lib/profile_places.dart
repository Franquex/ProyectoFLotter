import 'package:flutter/material.dart';
import 'package:places/login/pages/login_page.dart';
import 'package:places/login/user_session.dart';

class ProfilePlaces extends StatelessWidget {
  const ProfilePlaces({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Recuperamos los datos de la sesión guardada
    final Map<String, dynamic> userData = UserSession.data;

    // Validación segura
    final String nombres = userData['nombres'] ?? 'Usuario';
    final String apellidos = userData['apellidos'] ?? '';
    final String usuario = userData['usuario'] ?? 'desconocido';
    final String correo = userData['correo'] ?? 'No registrado';
    final String celular = userData['celular'] ?? 'No registrado';

    // Obtenemos la primera letra del nombre (si existe) para el avatar
    final String inicial = nombres.isNotEmpty ? nombres[0].toUpperCase() : 'U';

    return Container(
      color: const Color(0xFFFFFFFF),
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 50.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "Mi Perfil",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 30),

          // Imagen de perfil circular
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFF4268D3),
            child: Text(
              inicial,
              style: const TextStyle(fontSize: 40, color: const Color(0xFFFFFFFF)),
            ),
          ),
          const SizedBox(height: 20),

          // Tarjeta de Datos del Usuario
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildProfileRow(Icons.person, "Nombre", "$nombres $apellidos"),
                  const Divider(),
                  _buildProfileRow(Icons.account_circle, "Usuario", "@$usuario"),
                  const Divider(),
                  _buildProfileRow(Icons.email, "Correo", correo),
                  const Divider(),
                  _buildProfileRow(Icons.phone_android, "Celular", celular),
                ],
              ),
            ),
          ),

          const Spacer(), // Empuja el botón hacia abajo

          // Botón de Cerrar Sesión
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, color: const Color(0xFFFFFFFF)),
              label: const Text(
                "Cerrar Sesión",
                style: TextStyle(fontSize: 18, color: const Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                // 1. Limpiamos los datos en memoria
                UserSession.clear();

                // 2. Destruimos la pantalla saliendo desde la Raíz (rootNavigator)
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                      (Route<dynamic> route) => false,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  // Widget de ayuda para construir las filas de texto
  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF574ACF), size: 28),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text(
                value,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}