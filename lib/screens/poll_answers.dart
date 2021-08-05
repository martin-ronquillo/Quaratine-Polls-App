import 'package:flutter/material.dart';
import 'package:polls_app/blocs/option_Bloc.dart';
import 'package:polls_app/blocs/provider.dart';
import 'package:polls_app/models/options_model.dart';
import 'package:polls_app/models/polls_model.dart';
import 'package:polls_app/models/questions_model.dart';
import 'package:polls_app/providers/answer_provider.dart';
import 'package:polls_app/providers/option_provider.dart';
import 'package:polls_app/widgets/cardContainer.dart';
// import 'package:polls_app/models/questions_model.dart';
// import 'package:polls_app/providers/question_provider.dart';

class PollAnswers extends StatefulWidget {
  const PollAnswers({Key? key}) : super(key: key);

  @override
  _PollAnswersState createState() => _PollAnswersState();
}

class _PollAnswersState extends State<PollAnswers> {
  //para las respuestas de las preguntas bool
  Map<String, bool> radioMap = {};
  //Para la respuesta de las preguntas check
  Map<String, bool> checkMap = {};
  //Para los Text
  //Para las respuestas Text, Integer, Float
  Map<String, TextEditingController> controllersMap = {};
  //Recupera solo el texto de los controllers para pasarlos al API
  Map<String, dynamic> controllersTextMap = {};
  //Para recuperar las respuestas Multi Check
  //Guarda el id de la pregunta con un mapa de sus opciones
  Map<String, dynamic> checkQuestionOptionsMap = {};
  //Guarda el id de las opciones con su bool
  Map<String, bool> checkOptionsMap = {};

  final optionProvider = new OptionProvider();
  final answerProvider = new AnswerProvider();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  setSelectedRadio(int id, bool val) {
    setState(() {
      radioMap['$id'] = val;
    });
  }

  setCheck(int id, bool val) {
    setState(() {
      checkMap['$id'] = val;
      // print(checkMap);
    });
  }

  setOptionsCheck(int questionId, int optionId, bool val) {
    setState(() {
      checkOptionsMap['$optionId'] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final optionsBloc = Provider.optionBloc(context);
    PollsModel poll = arguments['poll'];
    List<QuestionsModel> questions = arguments['questions'];

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              '${poll.pollReason} - ${poll.id}',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                onPressed: () => _saveAnswerDB(),
              )
            ],
            backgroundColor: Colors.transparent,
            elevation: 0),
        body: _questions(questions, optionsBloc));
  }

  Widget _questions(List<QuestionsModel> questions, OptionBloc optionBloc) {
    final size = MediaQuery.of(context).size;

    //Lista de widgets de las preguntas generadas
    final questionType = <Widget>[];

    questions.forEach((element) {
      if (element.type == 'Bool') {
        //Se puede eliminar pero se perdera el indice de la pregunta
        //si la respuesta del usuario llegara a quedar en blanco
        radioMap[element.id.toString()] == null
            ? radioMap[element.id.toString()] = false
            // ignore: unnecessary_statements
            : radioMap[element.id.toString()];

        final addQuestion = CardContainer(widgetsType: 
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${element.question} ${element.required == 1 ? '*' : ''}',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Verdadero', style: TextStyle(fontSize: 18)),
                  Radio(
                    groupValue: radioMap[element.id.toString()],
                    value: true,
                    onChanged: (value) {
                      setSelectedRadio(element.id as int, value as bool);
                    },
                  ),
                  SizedBox(width: size.width * 0.1),
                  Text('Falso', style: TextStyle(fontSize: 18)),
                  Radio(
                    groupValue: radioMap[element.id.toString()],
                    value: false,
                    onChanged: (value) {
                      setSelectedRadio(element.id as int, value as bool);
                    },
                  )
                ],
              )
            ],
          ));

        questionType.add(addQuestion);
      }

      if (element.type == 'Check') {
        final addQuestion = CardContainer(widgetsType: 
        CheckboxListTile(
          title: Text('${element.question} ${element.required == 1 ? '*' : ''}',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
          value: checkMap[element.id.toString()] == null
              ? checkMap[element.id.toString()] = false
              : checkMap[element.id.toString()],
          onChanged: (value) => setCheck(element.id as int, value!),
        ));

        questionType.add(addQuestion);
      }

      if (element.type == 'Multi Checker') {
        checkQuestionOptionsMap[element.id.toString()] = {};

        bool? _optionsMethod(OptionsModel option) {
          checkOptionsMap[option.id.toString()] == null
              ? checkOptionsMap[option.id.toString()] = false
              : checkOptionsMap[option.id.toString()];

          // if (element.id == option.questionId) {
          print(
              'element: ${element.id}, option.question: ${option.questionId}');
          // Map<String, Map> optionsTemp = {};

          // checkQuestionOptionsMap[element.id.toString()] =
          //     checkOptionsMap[option.id.toString()];

          checkQuestionOptionsMap.update(
              element.id.toString(), (value) => checkOptionsMap);
          print(checkQuestionOptionsMap);
          // } else {
          //   print('limpiando');
          //   checkOptionsMap.clear();
          //   print(checkOptionsMap);
          // }
          return checkOptionsMap[option.id.toString()];
        }

        //recorre las opciones del Multi Checker
        List<Widget> _optionsWidgetsList() {
          final optionsList = <Widget>[];

          // checkOptionsMap.clear();

          element.options!.forEach((option) => optionsList.add(
                CheckboxListTile(
                    title: Text(option.option.toString(),
                        style: TextStyle(fontSize: 16)),
                    value: _optionsMethod(option),
                    // value: checkOptionsMap[option.id.toString()] == null
                    //     ? checkOptionsMap[option.id.toString()] = false
                    //     : checkOptionsMap[option.id.toString()],
                    onChanged: (value) => setOptionsCheck(
                        element.id as int, option.id as int, value!)),
              ));

          // checkQuestionOptionsMap[element.id.toString()] = checkOptionsMap;
          // print(checkQuestionOptionsMap);
          // print(checkOptionsMap);

          return optionsList;
        }
        
        final addQuestion = CardContainer(widgetsType:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${element.question} ${element.required == 1 ? '*' : ''}',
                  style:
                      TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              Divider(),
              Column(children: _optionsWidgetsList())
            ],
          )
        );

        questionType.add(addQuestion);
      }

      if (element.type == 'Text' ||
          element.type == 'Integer' ||
          element.type == 'Float') {
        TextEditingController optionController = new TextEditingController();

        // optionController.text = '';
        controllersTextMap[element.id.toString()] != null
            // ignore: unnecessary_statements
            ? controllersTextMap[element.id.toString()]
            : controllersTextMap[element.id.toString()] = '';

        final addQuestion = Column(children: [
          Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 5))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      '${element.question} ${element.required == 1 ? '*' : ''}',
                      style:
                          TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
                  Divider(),
                  TextFormField(
                    controller: controllersMap[element.id.toString()] == null
                        ? controllersMap[element.id.toString()] =
                            optionController
                        : controllersMap[element.id.toString()],
                    keyboardType: _keyboardType(element.type.toString()),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0)),
                      labelText: 'Respuesta',
                      // helperText: 'Puede incluir signos',
                    ),
                    onSaved: (value) => () {},
                    onChanged: (value) {
                      controllersTextMap[element.id.toString()] =
                          controllersMap[element.id.toString()]!.text;
                      setState(() {});
                    },
                  ),
                ],
              )),
          SizedBox(
            height: 20,
          )
        ]);

        questionType.add(addQuestion);
      }
    });

    return SingleChildScrollView(
      child: Container(
          // color: Colors.black12,
          padding: EdgeInsets.all(10.0),
          child: Form(
              key: _formKey,
              child: Column(
                children: questionType,
              ))),
    );
  }

  // Widget _cardContainer(Widget _widgetsType) {
  //   return Column(children: [
  //     Container(
  //       padding: EdgeInsets.all(15.0),
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(20.0),
  //           color: Colors.white,
  //           boxShadow: [
  //             BoxShadow(
  //                 color: Colors.grey.withOpacity(0.3),
  //                 spreadRadius: 5,
  //                 blurRadius: 7,
  //                 offset: Offset(0, 5))
  //           ]),
  //       child: _widgetsType
  //     ),
  //     SizedBox(
  //       height: 20,
  //     )
  //   ]);
  // }

  TextInputType _keyboardType(String type) {
    TextInputType defType = TextInputType.text;

    if (type == 'Text') {
      defType = TextInputType.text;
    }
    if (type == 'Integer') {
      defType = TextInputType.number;
    }
    if (type == 'Float') {
      defType = TextInputType.numberWithOptions();
    }

    return defType;
  }

  _saveAnswerDB() async {
    final info;
    final List<String> _options = [];
    info = await answerProvider.saveAnswer(
        radioMap, checkMap, controllersTextMap, checkOptionsMap);
    // controllersList.forEach((element) => _options.add(element.text));

    // if (questions.id == null) {
    //   infoQuestion =
    //       await questionProvider.saveQuestion(poll.id!, questions, _options);

    //   if (infoQuestion!['success']) {
    //     await optionProvider.saveOptions(
    //         infoQuestion['data']['id'] as int, _options);

    //     setState(() {
    //       questions.id = null;
    //       questions.question = '';
    //       questions.required = 0;
    //       _preguntaController.clear();
    //       requiredQuestion = false;
    //       _options.clear();
    //       controllersList.clear();
    //       drawOptions.clear();

    //       // questions.required = 0;
    //     });

    //     mostrarSnackbar('Pregunta agregada!', true);
    //   } else {
    //     mostrarSnackbar('Error al guardar la pregunta', false);
    //   }
    // } else {
    //   infoQuestion =
    //       await questionProvider.updateQuestion(poll.id!, questions, _options);

    //   if (infoQuestion!['success']) {
    //     setState(() {
    //       questions.id = null;
    //       questions.question = '';
    //       questions.required = null;
    //       _preguntaController.clear();
    //       requiredQuestion = false;
    //       // questions.required = 0;
    //       _addQuestion = false;
    //     });
    //     mostrarSnackbar('Pregunta actualizada!', true);
    //   } else {
    //     mostrarSnackbar('Error al actualizar la pregunta', false);
    //   }
    // }
  }

  void mostrarSnackbar(String mensaje, bool status) {
    final snackBar = SnackBar(
      backgroundColor: status ? Colors.greenAccent : Colors.red,
      content: Text(mensaje),
      duration: Duration(milliseconds: 2000),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
