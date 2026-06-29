import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:places/login/pages/login_page.dart';
import 'package:places/login/theme.dart';
import 'package:places/login/widgets/snackbar.dart';
import 'package:places/places_cupertino.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  String? _selectedGender;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        // Tonalidad más seria para el calendario
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.blueGrey.shade800,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        signupDateController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _handleSignUp() async {
    // LOGICA INTACTA
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

    final url = Uri.parse('http://18.221.108.46:8000/api/flutter/registro/');

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

      final decodedResponse = jsonDecode(response.body);

      if (response.statusCode == 201) {
        CustomSnackBar(context, const Text('¡Usuario creado en Postgres! Inicia sesión.'), backgroundColor: Colors.green);

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
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey.shade300), // Borde limpio
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text("Datos Personales", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 15.0),
                  _buildTextField(signupNameController, FontAwesomeIcons.user, 'Nombres'),
                  _buildSpacer(),
                  _buildTextField(signupFirstLastNameController, FontAwesomeIcons.users, 'Primer Apellido'),
                  _buildSpacer(),
                  _buildTextField(signupSecondLastNameController, FontAwesomeIcons.users, 'Segundo Apellido', isRequired: false),
                  _buildSpacer(),
                  _buildTextField(signupDateController, FontAwesomeIcons.calendar, 'Fecha de Nacimiento', readOnly: true, onTap: () => _selectDate(context)),
                  _buildSpacer(),
                  _buildGenderDropdown(),
                  _buildSpacer(),
                  _buildTextField(signupCIController, FontAwesomeIcons.idCard, 'Carnet de Identidad'),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(color: Colors.black12),
                  ),

                  const Text("Datos de Contacto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 15.0),
                  _buildTextField(signupCellController, FontAwesomeIcons.mobile, 'Celular', keyboardType: TextInputType.phone),
                  _buildSpacer(),
                  _buildTextField(signupPhoneController, FontAwesomeIcons.phone, 'Teléfono Fijo', keyboardType: TextInputType.phone, isRequired: false),
                  _buildSpacer(),
                  _buildTextField(signupAddressController, FontAwesomeIcons.mapLocation, 'Dirección'),

                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Divider(color: Colors.black12),
                  ),

                  const Text("Credenciales", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 15.0),
                  _buildTextField(signupUserController, FontAwesomeIcons.at, 'Nombre de Usuario'),
                  _buildSpacer(),
                  _buildTextField(signupEmailController, FontAwesomeIcons.envelope, 'Correo Electrónico', keyboardType: TextInputType.emailAddress),
                  _buildSpacer(),
                  _buildTextField(signupPasswordController, FontAwesomeIcons.lock, 'Contraseña', obscureText: true),
                  _buildSpacer(),
                  _buildTextField(signupConfirmPasswordController, FontAwesomeIcons.lock, 'Confirmar Contraseña', obscureText: true),
                ],
              ),
            ),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 25.0, bottom: 40.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey.shade800, // Color corporativo sólido
                  padding: const EdgeInsets.symmetric(vertical: 15.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                  elevation: 0,
                ),
                onPressed: _handleSignUp,
                child: const Text(
                  'REGISTRAR',
                  style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // MÉTODO VISUALMENTE FORMALIZADO (OutlineInputBorder)
  Widget _buildTextField(TextEditingController controller, dynamic icon, String labelText,
      {bool obscureText = false, TextInputType keyboardType = TextInputType.text, bool isRequired = true, bool readOnly = false, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      textInputAction: TextInputAction.next,
      style: const TextStyle(fontSize: 15.0, color: Colors.black87),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey.shade400)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2.0)),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(icon, color: Colors.blueGrey.shade700, size: 20.0),
        label: RichText(
          text: TextSpan(
            text: labelText,
            style: const TextStyle(fontSize: 15.0, color: Colors.black54),
            children: [
              if (isRequired) const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey.shade400)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.grey.shade400)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0), borderSide: BorderSide(color: Colors.blueGrey.shade800, width: 2.0)),
        filled: true,
        fillColor: Colors.grey.shade50,
        prefixIcon: Icon(FontAwesomeIcons.venusMars, color: Colors.blueGrey.shade700, size: 20.0),
        label: RichText(
          text: const TextSpan(
            text: 'Género',
            style: TextStyle(fontSize: 15.0, color: Colors.black54),
            children: [TextSpan(text: ' *', style: TextStyle(color: Colors.red))],
          ),
        ),
      ),
      value: _selectedGender,
      items: ['Femenino', 'Masculino', 'Otro', 'Prefiero no decirlo']
          .map((label) => DropdownMenuItem(
        value: label,
        child: Text(label, style: const TextStyle(fontSize: 15.0, color: Colors.black87)),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedGender = value;
          signupGenderController.text = value ?? '';
        });
      },
    );
  }

  // Reemplazamos la línea gris por espacio para un look más moderno y limpio
  Widget _buildSpacer() => const SizedBox(height: 15.0);
}