import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:places/login/pages/login_page.dart';
import 'package:places/login/theme.dart';
import 'package:places/login/widgets/snackbar.dart';
import 'package:places/places_cupertino.dart';
import 'package:places/login/pages/login_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  String? _selectedGender; // Para guardar la opción del menú desplegable

  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupFirstLastNameController = TextEditingController();
  TextEditingController signupSecondLastNameController = TextEditingController();
  TextEditingController signupCIController = TextEditingController();
  TextEditingController signupDateController = TextEditingController();
  TextEditingController signupGenderController = TextEditingController();
  TextEditingController signupAddressController = TextEditingController();
  TextEditingController signupPhoneController = TextEditingController();
  TextEditingController signupCellController = TextEditingController();
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupUserController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  // --- FUNCIÓN PARA EL CALENDARIO ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000), // Fecha por defecto al abrir
      firstDate: DateTime(1900),   // Límite hacia atrás
      lastDate: DateTime.now(),    // No pueden nacer en el futuro
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: CustomTheme.loginGradientStart,
              onPrimary: const Color(0xFFFFFFFF),
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        // Guardamos en el formato exacto que pide la base de datos YYYY-MM-DD
        signupDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _handleSignUp() async {
    // 1. VALIDACIÓN FRONTEND (Solo verificamos los obligatorios)
    if (signupNameController.text.isEmpty ||
        signupFirstLastNameController.text.isEmpty ||
        signupDateController.text.isEmpty ||
        signupGenderController.text.isEmpty ||
        signupCIController.text.isEmpty ||
        signupCellController.text.isEmpty ||
        signupAddressController.text.isEmpty ||
        signupUserController.text.isEmpty ||
        signupEmailController.text.isEmpty ||
        signupPasswordController.text.isEmpty) {
      CustomSnackBar(context, const Text('Faltan campos obligatorios por completar'), backgroundColor: Colors.orange);
      return;
    }

    if (!signupEmailController.text.contains('@')) {
      CustomSnackBar(context, const Text('Correo inválido'), backgroundColor: Colors.red);
      return;
    }

    if (signupPasswordController.text.length <= 8) {
      CustomSnackBar(context, const Text('Contraseña muy corta (mínimo 9)'), backgroundColor: Colors.red);
      return;
    }

    if (signupPasswordController.text != signupConfirmPasswordController.text) {
      CustomSnackBar(context, const Text('Las contraseñas no coinciden'), backgroundColor: Colors.red);
      return;
    }

    // 2. VALIDACIÓN BACKEND (127.0.0.1 para WEB)
    final url = Uri.parse('http://127.0.0.1:8000/api/flutter/registro/');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "nombres": signupNameController.text,
          "primer_apellido": signupFirstLastNameController.text,
          "segundo_apellido": signupSecondLastNameController.text,
          "ci": signupCIController.text,
          "fecha_nacimiento": signupDateController.text,
          "genero": signupGenderController.text,
          "direccion": signupAddressController.text,
          "telefono_fijo": signupPhoneController.text.isEmpty ? "0" : signupPhoneController.text,
          "celular": signupCellController.text,
          "correo_electronico": signupEmailController.text,
          "usuario": signupUserController.text,
          "password": signupPasswordController.text
        }),
      );

      // 3. RESPUESTA DEL BACKEND
      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        CustomSnackBar(context, const Text('¡Usuario creado en Postgres! Inicia sesión.'), backgroundColor: Colors.green);

        // RECARGAMOS LA PÁGINA PARA VOLVER AL LOGIN AUTOMÁTICAMENTE
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        });

      } else {
        CustomSnackBar(context, Text('Aviso: ${decodedResponse["error"]}'), backgroundColor: Colors.orange);
      }
    } catch (e) {
      CustomSnackBar(context, Text('Error interno: $e'), backgroundColor: Colors.red);
      print("EL ERROR REAL ES: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(top: 23.0),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 2.0,
              color: const Color(0xFFFFFFFF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
              child: Container(
                width: 300.0,
                child: Column(
                  children: <Widget>[
                    // --- DATOS PERSONALES ---
                    _buildTextField(signupNameController, FontAwesomeIcons.user, 'Nombres'),
                    _buildDivider(),
                    _buildTextField(signupFirstLastNameController, FontAwesomeIcons.users, 'Primer Apellido'),
                    _buildDivider(),
                    _buildTextField(signupSecondLastNameController, FontAwesomeIcons.users, 'Segundo Apellido', isRequired: false),
                    _buildDivider(),
                    // Campo de Fecha con Calendario
                    _buildTextField(signupDateController, FontAwesomeIcons.calendar, 'Fecha de Nacimiento', readOnly: true, onTap: () => _selectDate(context)),
                    _buildDivider(),
                    // Menú desplegable para Género
                    _buildGenderDropdown(),
                    _buildDivider(),
                    _buildTextField(signupCIController, FontAwesomeIcons.idCard, 'Carnet de Identidad'),
                    _buildDivider(),

                    // --- DATOS DE CONTACTO ---
                    _buildTextField(signupCellController, FontAwesomeIcons.mobile, 'Celular', keyboardType: TextInputType.phone),
                    _buildDivider(),
                    _buildTextField(signupPhoneController, FontAwesomeIcons.phone, 'Teléfono Fijo', keyboardType: TextInputType.phone, isRequired: false),
                    _buildDivider(),
                    _buildTextField(signupAddressController, FontAwesomeIcons.mapLocation, 'Dirección'),
                    _buildDivider(),

                    // --- CREDENCIALES DE LA APP ---
                    _buildTextField(signupUserController, FontAwesomeIcons.at, 'Nombre de Usuario'),
                    _buildDivider(),
                    _buildTextField(signupEmailController, FontAwesomeIcons.envelope, 'Correo Electrónico', keyboardType: TextInputType.emailAddress),
                    _buildDivider(),
                    _buildTextField(signupPasswordController, FontAwesomeIcons.lock, 'Contraseña', obscureText: true),
                    _buildDivider(),
                    _buildTextField(signupConfirmPasswordController, FontAwesomeIcons.lock, 'Confirmar Contraseña', obscureText: true),
                  ],
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 20.0, bottom: 40.0),
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
                  child: Text(
                    'REGISTRAR',
                    style: TextStyle(color: Colors.white, fontSize: 25.0, fontFamily: 'WorkSansBold'),
                  ),
                ),
                onPressed: _handleSignUp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MÉTODO MODIFICADO PARA ACEPTAR EL ASTERISCO ROJO Y READONLY (CALENDARIO)
  Widget _buildTextField(TextEditingController controller, dynamic icon, String labelText,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text, bool isRequired = true, bool readOnly = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
        textInputAction: TextInputAction.next, // <--- ESTO ARREGLA EL TAB Y EL BOTÓN SIGUIENTE
        style: const TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: FaIcon(icon, color: Colors.black, size: 22.0),
          label: RichText(
            text: TextSpan(
              text: labelText,
              style: const TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black54),
              children: [
                if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // MÉTODO NUEVO PARA EL DESPLEGABLE DE GÉNERO
  Widget _buildGenderDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          border: InputBorder.none,
          icon: const FaIcon(FontAwesomeIcons.venusMars, color: Colors.black, size: 22.0),
          label: RichText(
            text: const TextSpan(
              text: 'Género',
              style: TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black54),
              children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
            ),
          ),
        ),
        value: _selectedGender,
        items: ['Femenino', 'Masculino', 'Otro', 'Prefiero no decirlo']
            .map((label) => DropdownMenuItem(
          value: label,
          child: Text(label, style: const TextStyle(fontFamily: 'WorkSansSemiBold', fontSize: 16.0, color: Colors.black)),
        ))
            .toList(),
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
            signupGenderController.text = value ?? ''; // Guardamos en el controlador para enviarlo a Django
          });
        },
      ),
    );
  }

  Widget _buildDivider() => Container(width: 250.0, height: 1.0, color: Colors.grey[400]);
}