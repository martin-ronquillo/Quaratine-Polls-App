import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:polls_app/blocs/validators.dart';
import 'package:polls_app/providers/poll_provider.dart';

import 'package:polls_app/models/polls_model.dart';

class PollBloc with Validator {
  final _pollController = new BehaviorSubject<List<PollsModel>>();
  final _pollUserController = new BehaviorSubject<List<PollsModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  //Validators
  final _reasonController = BehaviorSubject<String>();
  final _subtitleController = BehaviorSubject<String>();
  final _samplingsController = BehaviorSubject<String>();
  //

  final pollProvider = new PollProvider();

  //Recuperar datos del Stream
  Stream<List<PollsModel>> get pollsStream => _pollController.stream;
  Stream<List<PollsModel>> get pollsUserStream => _pollUserController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;
  Stream<String> get reasonStream =>
      _reasonController.stream.transform(validaPollReason);
  Stream<String> get subtitleStream =>
      _subtitleController.stream.transform(validaPollSubtitle);
  Stream<String> get samplingStream =>
      _samplingsController.stream.transform(valdiaPollSampling);
  Stream<bool> get formValidStream => _subtitleController.hasValue
      ? Rx.combineLatest3(
          reasonStream, subtitleStream, samplingStream, (a, b, c) => true)
      : Rx.combineLatest2(reasonStream, samplingStream, (a, b) => true);

  //Insertar valores al stream
  Function(String) get changeReason => _reasonController.sink.add;
  Function(String) get changeSubtitle => _subtitleController.sink.add;
  Function(String) get chageSamplings => _samplingsController.sink.add;

  //Obtener el ultimo valor ingresador a los streams
  String get reason => _reasonController.value;
  String get subtitle => _subtitleController.value;
  String get samplings => _samplingsController.value;

  //Carga en el home las encuestas que el usuario ha realizado
  void chargePolls() async {
    final polls = await pollProvider.getPolls();

    _pollController.sink.add(polls);
  }

  void chargeUserPolls() async {
    final polls = await pollProvider.getUserPolls();

    _pollUserController.sink.add(polls);
  }

  // void drainStream() {
  //   _subtitleController.value = '';
  //   _reasonController.value = '';
  //   _samplingsController.value = '1';
  // }

  //destroy on close
  void dispose() {
    _pollController.close();
    _pollUserController.close();
    _cargandoController.close();
    _reasonController.close();
    _subtitleController.close();
    _samplingsController.close();
  }
}
