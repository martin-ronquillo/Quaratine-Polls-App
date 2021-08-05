import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:polls_app/blocs/validators.dart';
import 'package:polls_app/providers/option_provider.dart';

import 'package:polls_app/models/options_model.dart';

class OptionBloc with Validator {
  final _optionController = new BehaviorSubject<List<OptionsModel>>();

  final optionProvider = new OptionProvider();

  //Recuperar datos del Stream
  Stream<List<OptionsModel>> get optionsStream => _optionController.stream;

  void chargeOptions(int id) async {
    final options = await optionProvider.getOptions(id);

    _optionController.sink.add(options);
  }

  void dispose() {
    _optionController.close();
  }
}
