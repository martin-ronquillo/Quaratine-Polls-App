import 'package:polls_app/providers/question_provider.dart';
import 'package:rxdart/rxdart.dart';

import 'package:polls_app/blocs/validators.dart';
import 'package:polls_app/models/questions_model.dart';

class QuestionBloc with Validator {
  final questionProvider = new QuestionProvider();

  final _questionController = new BehaviorSubject<List<QuestionsModel>>();
  //Validators
  final _preguntaController = new BehaviorSubject<String>();

  //Recuperar datos del stream
  Stream<List<QuestionsModel>> get questionStream => _questionController.stream;
  Stream<String> get preguntaStream =>
      _preguntaController.stream.transform(validaQuestion);

  //Insertar valores al stream
  Function(String) get changePregunta => _preguntaController.sink.add;

  //Obtener ultimo valor ingresado a los streams
  String get pregunta => _preguntaController.value;

  void chargeQuestions(int id) async {
    final questions = await questionProvider.getQuestionsPolls(id);

    _questionController.sink.add(questions);
  }

  void dispose() {
    _questionController.close();
    _preguntaController.close();
  }
}
