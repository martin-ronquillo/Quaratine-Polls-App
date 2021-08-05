import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:polls_app/blocs/validators.dart';

class LoginBloc with Validator {
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  //Recuperar datos del Stream
  Stream<String> get emailStream =>
      _emailController.stream.transform(validaEmail);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(validaPassword);
  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  //Insertar valores al stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Obtener el ultimo valor ingresador a los streams
  String get email => _emailController.value;
  String get password => _passwordController.value;

  dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
