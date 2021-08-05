import 'package:flutter/material.dart';

import 'package:flutter/scheduler.dart';

import 'package:polls_app/blocs/provider.dart';
import 'package:polls_app/providers/user_provider.dart';
import 'package:polls_app/user_preferences/user_preferences.dart';
import 'package:polls_app/utils/utils.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _prefs = new PreferenciasUsuario();

  final usuarioProvider = new UserProvider();
  bool login = true;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  //Inicia sesion de forma asincrona, comprueba si existe un token
  //valido en la app y en la base de datos
  Future<void> _fetchData() async {
    if (_prefs.token.toString() != '') {
      Map info = await usuarioProvider.validaToken();

      if (info['status']) {
        SchedulerBinding.instance!.addPostFrameCallback((_) {
          Navigator.pushReplacementNamed(context, 'home');
        });
      } else {
        setState(() {
          login = false;
        });
        mostrarAlerta(context, 'Error al iniciar sesion');
      }
    } else {
      login = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _crearFondo(context),
        login == false ? _loginForm(context) : _loadingUserInfo(context),
      ]),
    );
  }

  Widget _loginForm(BuildContext context) {
    final bloc = Provider.of(context);
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.all(30.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                SizedBox(height: size.height * 0.01),
                _email(bloc),
                SizedBox(height: size.height * 0.05),
                _password(bloc),
                SizedBox(height: size.height * 0.07),
                _logginButton(bloc)
              ],
            ),
          ),
          TextButton(
            child: Text('Crear una nueva cuenta'),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, 'register'),
          ),
        ],
      ),
    );
  }

  Widget _email(LoginBloc bloc) {
    return StreamBuilder(
      stream: bloc.emailStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          // padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'example@email.com',
              labelText: 'Correo electronico',
              // counterText: snapshot.data,
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onChanged: (value) => bloc.changeEmail(value),
          ),
        );
      },
    );
  }

  Widget _password(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.passwordStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
                labelText: 'Contraseña',
                errorText:
                    snapshot.error != null ? snapshot.error.toString() : null,
              ),
              onChanged: bloc.changePassword,
            ),
          );
        });
  }

  Widget _logginButton(LoginBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0))),
            ),
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Ingresar',
                  style: TextStyle(fontSize: 16),
                )),
            onPressed: snapshot.hasData ? () => _login(context, bloc) : null,
          );
        });
  }

  _login(BuildContext context, LoginBloc bloc) async {
    Map info = await usuarioProvider.login(bloc.email, bloc.password);

    if (info['ok']) {
      Navigator.pushReplacementNamed(context, 'home');
    } else {
      mostrarAlerta(context, info['mensaje']);
    }
  }

  Widget _loadingUserInfo(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // _validaToken(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          SafeArea(
              child: Container(
            height: 180.0,
          )),
          Container(
              width: size.width * 0.85,
              height: size.height * 0.4,
              margin: EdgeInsets.symmetric(vertical: 30.0),
              padding: EdgeInsets.all(30.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
              ),
              child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }

  Widget _crearFondo(BuildContext context) {
    final size = MediaQuery.of(context).size;

    var fondoMorado = Container(
      height: size.height * 0.4,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color.fromRGBO(63, 63, 156, 1.0),
          Color.fromRGBO(90, 70, 178, 1.0)
        ]),
      ),
    );

    var circulo = Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Color.fromRGBO(255, 255, 255, 0.07)),
    );

    return Stack(children: [
      fondoMorado,
      Positioned(top: -20, left: -20, child: circulo),
      Positioned(top: 120, left: 50, child: circulo),
      Positioned(top: 50, right: 20, child: circulo),
      Positioned(top: 220, right: 70, child: circulo),
      Container(
        padding: EdgeInsets.only(top: size.height * 0.1),
        child: Column(
          children: [
            Icon(Icons.poll_outlined, color: Colors.white, size: 50),
            SizedBox(
              height: 20.0,
              width: double.infinity,
            ),
            Text(
              'DoPolls',
              style: TextStyle(color: Colors.white, fontSize: 30.0),
            )
          ],
        ),
      )
    ]);
  }
}
