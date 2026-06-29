import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:places/places_cupertino.dart';
import 'package:places/login/theme.dart';
import 'package:places/login/widgets/snackbar.dart';
import 'package:places/login/user_session.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  final FocusNode focusNodeEmail = FocusNode();
  final FocusNode focusNodePassword = FocusNode();

  bool _obscureTextPassword = true;

  @override
  void dispose() {
    focusNodeEmail.dispose();
    focusNodePassword.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // LOGICA INTACTA
    String email = loginEmailController.text;
    String password = loginPasswordController.text;

    if (email.isEmpty || password.isEmpty) {
      CustomSnackBar(context, const Text('Completa todos los campos'), backgroundColor: Colors.orange);
      return;
    }
    if (!email.contains('@')) {
      CustomSnackBar(context, const Text('Formato de correo no válido'), backgroundColor: Colors.red);
      return;
    }

    final url = Uri.parse('http://18.221.108.46:8000/api/flutter/login/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 200) {
        UserSession.data = decodedResponse['user_data'];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PlacesCupertino()),
        );
      } else {
        CustomSnackBar(context, Text('${decodedResponse["error"]}'), backgroundColor: Colors.red);
      }
    } catch (e) {
      CustomSnackBar(context, const Text('Error de conexión con el servidor'), backgroundColor: Colors.red);
    }
  }

  void _showForgotPasswordDialog() {
    TextEditingController resetEmailController = TextEditingController();
    TextEditingController resetPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)), // Borde más formal
          title: const Text("Recuperar Cuenta", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Ingresa el correo con el que te registraste y la nueva contraseña.",
                  style: TextStyle(color: Colors.black54)),
              const SizedBox(height: 15),
              TextField(
                controller: resetEmailController,
                decoration: const InputDecoration(
                  labelText: "Correo Electrónico",
                  prefixIcon: Icon(Icons.email, color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 15),
              TextField(
                controller: resetPasswordController,
                decoration: const InputDecoration(
                  labelText: "Nueva Contraseña",
                  prefixIcon: Icon(Icons.lock, color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.of(context).pop(),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey.shade800, elevation: 0),
              child: const Text("Actualizar", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                // LOGICA INTACTA
                String email = resetEmailController.text;
                String nuevaPass = resetPasswordController.text;

                if (email.isEmpty || nuevaPass.isEmpty) {
                  CustomSnackBar(context, const Text('Llena ambos campos'), backgroundColor: Colors.orange);
                  return;
                }

                final url = Uri.parse('http://192.168.0.103:8000/api/flutter/recuperar/');
                try {
                  final response = await http.post(
                    url,
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({"email": email, "nueva_password": nuevaPass}),
                  );
                  final decodedResponse = jsonDecode(response.body);

                  if (response.statusCode == 200) {
                    Navigator.of(context).pop();
                    CustomSnackBar(context, const Text('¡Contraseña actualizada con éxito!'), backgroundColor: Colors.green);
                  } else {
                    CustomSnackBar(context, Text('${decodedResponse["error"]}'), backgroundColor: Colors.red);
                  }
                } catch (e) {
                  CustomSnackBar(context, const Text('Error de conexión con el servidor'), backgroundColor: Colors.red);
                }
              },
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: <Widget>[
                TextField(
                  focusNode: focusNodeEmail,
                  controller: loginEmailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(fontSize: 15.0, color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(FontAwesomeIcons.envelope, color: Colors.blueGrey.shade700, size: 20.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  ),
                  onSubmitted: (_) => focusNodePassword.requestFocus(),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  focusNode: focusNodePassword,
                  controller: loginPasswordController,
                  obscureText: _obscureTextPassword,
                  style: const TextStyle(fontSize: 15.0, color: Colors.black87),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(FontAwesomeIcons.lock, color: Colors.blueGrey.shade700, size: 20.0),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    suffixIcon: GestureDetector(
                      onTap: _toggleLogin,
                      child: Icon(
                        _obscureTextPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                        size: 20.0, color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  onSubmitted: (_) => _handleLogin(),
                  textInputAction: TextInputAction.go,
                ),
              ],
            ),
          ),

          const SizedBox(height: 25.0),

          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey.shade800, // Estilo sólido corporativo
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                elevation: 0,
              ),
              onPressed: _handleLogin,
              child: const Text('INGRESAR', style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
            ),
          ),

          const SizedBox(height: 15.0),

          TextButton(
            onPressed: _showForgotPasswordDialog,
            child: Text(
              '¿Olvidaste tu Contraseña?',
              style: TextStyle(
                decoration: TextDecoration.underline,
                color: Colors.blueGrey.shade700, // Texto oscuro en lugar de blanco
                fontSize: 15.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }
}