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

    final url = Uri.parse('http://127.0.0.1:8000/api/flutter/login/');
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

  // --- NUEVA FUNCIÓN: RECUPERAR CONTRASEÑA ---
  void _showForgotPasswordDialog() {
    TextEditingController resetEmailController = TextEditingController();
    TextEditingController resetPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          title: const Text("Recuperar Cuenta", style: TextStyle(fontFamily: 'WorkSansBold')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Ingresa el correo con el que te registraste y la nueva contraseña.",
                  style: TextStyle(fontFamily: 'WorkSansMedium')),
              const SizedBox(height: 15),
              TextField(
                controller: resetEmailController,
                decoration: const InputDecoration(
                  labelText: "Correo Electrónico",
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: resetPasswordController,
                decoration: const InputDecoration(
                  labelText: "Nueva Contraseña",
                  prefixIcon: Icon(Icons.lock),
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
              style: ElevatedButton.styleFrom(backgroundColor: CustomTheme.loginGradientStart),
              child: const Text("Actualizar", style: TextStyle(color: Colors.white)),
              onPressed: () async {
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
                    Navigator.of(context).pop(); // Cierra el pop-up
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
      padding: const EdgeInsets.only(top: 23.0),
      child: Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Card(
                elevation: 2.0,
                color: const Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                child: Container(
                  width: 300.0,
                  height: 190.0,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodeEmail,
                          controller: loginEmailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            icon: FaIcon(FontAwesomeIcons.envelope, color: Colors.black, size: 22.0),
                            hintText: 'Correo',
                            hintStyle: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                          ),
                          onSubmitted: (_) => focusNodePassword.requestFocus(),
                        ),
                      ),
                      Container(width: 250.0, height: 1.0, color: Colors.grey[400]),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                        child: TextField(
                          focusNode: focusNodePassword,
                          controller: loginPasswordController,
                          obscureText: _obscureTextPassword,
                          style: const TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            icon: const FaIcon(FontAwesomeIcons.lock, size: 22.0, color: Colors.black),
                            hintText: 'Contraseña',
                            hintStyle: const TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 17.0),
                            suffixIcon: GestureDetector(
                              onTap: _toggleLogin,
                              child: FaIcon(
                                _obscureTextPassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash,
                                size: 15.0, color: Colors.black,
                              ),
                            ),
                          ),
                          onSubmitted: (_) => _handleLogin(),
                          textInputAction: TextInputAction.go,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 170.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: CustomTheme.loginGradientStart, offset: Offset(1.0, 6.0), blurRadius: 20.0),
                    BoxShadow(color: CustomTheme.loginGradientEnd, offset: Offset(1.0, 6.0), blurRadius: 20.0),
                  ],
                  gradient: LinearGradient(
                      colors: <Color>[CustomTheme.loginGradientEnd, CustomTheme.loginGradientStart],
                      begin: FractionalOffset(0.2, 0.2), end: FractionalOffset(1.0, 1.0),
                      stops: <double>[0.0, 1.0], tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                  highlightColor: Colors.transparent,
                  splashColor: CustomTheme.loginGradientEnd,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 42.0),
                    child: Text('INGRESAR', style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'WorkSansBold')),
                  ),
                  onPressed: _handleLogin,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: TextButton(
                onPressed: _showForgotPasswordDialog, // Conectado al nuevo PopUp
                child: const Text(
                  'Olvidaste tu Contraseña?',
                  style: TextStyle(
                      decoration: TextDecoration.underline, color: const Color(0xFFFFFFFF),
                      fontSize: 16.0, fontFamily: 'WorkSansMedium'),
                )),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[Colors.white10, Colors.white],
                        begin: FractionalOffset(0.0, 0.0), end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0], tileMode: TileMode.clamp),
                  ),
                  width: 100.0, height: 1.0,
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        colors: <Color>[Colors.white, Colors.white10],
                        begin: FractionalOffset(0.0, 0.0), end: FractionalOffset(1.0, 1.0),
                        stops: <double>[0.0, 1.0], tileMode: TileMode.clamp),
                  ),
                  width: 100.0, height: 1.0,
                ),
              ],
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