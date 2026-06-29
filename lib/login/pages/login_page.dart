import 'package:flutter/material.dart';
import 'package:places/login/pages/widgets/sign_in.dart';
import 'package:places/login/pages/widgets/sign_up.dart';
import 'package:places/login/theme.dart';
import 'package:places/login/utils/bubble_indicator_painter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;

  // Colores formales para el selector
  Color left = Colors.white;
  Color right = Colors.grey.shade500;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fondo sobrio y corporativo
        backgroundColor: Colors.grey.shade100,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0, bottom: 20.0),
                    child: _buildMenuBar(context),
                  ),
                  Expanded(
                    flex: 2,
                    child: PageView(
                      controller: _pageController,
                      physics: const ClampingScrollPhysics(),
                      onPageChanged: (int i) {
                        FocusScope.of(context).requestFocus(FocusNode());
                        if (i == 0) {
                          setState(() {
                            right = Colors.grey.shade500;
                            left = Colors.white;
                          });
                        } else if (i == 1) {
                          setState(() {
                            right = Colors.white;
                            left = Colors.grey.shade500;
                          });
                        }
                      },
                      children: <Widget>[
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: const SignIn(),
                        ),
                        ConstrainedBox(
                          constraints: const BoxConstraints.expand(),
                          child: const SignUp(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: const BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: BubbleIndicatorPainter(
            pageController: _pageController,
            dxTarget: 125.0,
            dxEntry: 25.0,
            radius: 21.0,
            dy: 25.0), // Mantenemos tu painter, asumiendo que funciona con el tema formal
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignInButtonPress,
                child: Text(
                  'EXISTE',
                  style: TextStyle(
                      color: left == Colors.white ? Colors.black : left,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.transparent),
                ),
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'NUEVO',
                  style: TextStyle(
                      color: right == Colors.white ? Colors.black : right,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'WorkSansSemiBold'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: const Duration(milliseconds: 500), curve: Curves.decelerate);
  }
}