import 'dart:async';

class Validator {
  //Valida email en login
  final validaEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = new RegExp(pattern.toString());

    if (regExp.hasMatch(email)) {
      sink.add(email);
    } else {
      sink.addError('Email invalido');
    }
  });
  //Valida Password en el login
  final validaPassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length >= 3) {
      sink.add(password);
    } else {
      sink.addError('Inserte mas de 6 caracteres');
    }
  });
  //Valida razon de poll
  final validaPollReason = StreamTransformer<String, String>.fromHandlers(
      handleData: (reason, sink) {
    if (reason.length > 35) {
      sink.addError('No puede contener mas de 35 caracteres');
    } else {
      sink.add(reason);
    }
  });
  //Valida subtitulo de poll
  final validaPollSubtitle = StreamTransformer<String, String>.fromHandlers(
      handleData: (subtitle, sink) {
    if (subtitle.length > 35) {
      sink.addError('No puede contener mas de 35 caracteres');
    } else {
      sink.add(subtitle);
    }
  });
  //Valida la cantidad de muestras de poll
  final valdiaPollSampling = StreamTransformer<String, String>.fromHandlers(
      handleData: (samplings, sink) {
    if (int.tryParse(samplings) is int && samplings.length < 8) {
      sink.add(samplings);
    } else {
      sink.addError('Solo numeros enteros y menores a 10Millones');
    }
  });
  //Valida la pregunta de Question
  final validaQuestion = StreamTransformer<String, String>.fromHandlers(
      handleData: (samplings, sink) {
    if (samplings.length >= 4) {
      sink.add(samplings);
    } else {
      sink.addError('Pregunta invalida');
    }
  });
}
