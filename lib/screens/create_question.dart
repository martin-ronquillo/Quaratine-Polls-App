import 'package:flutter/material.dart';
import 'package:polls_app/blocs/provider.dart';
import 'package:polls_app/blocs/question_bloc.dart';
import 'package:polls_app/models/polls_model.dart';
import 'package:polls_app/models/questions_model.dart';
import 'package:polls_app/providers/option_provider.dart';
import 'package:polls_app/providers/question_provider.dart';

class CreateQuestion extends StatefulWidget {
  const CreateQuestion({Key? key}) : super(key: key);

  @override
  _CreateQuestionState createState() => _CreateQuestionState();
}

class _CreateQuestionState extends State<CreateQuestion> {
  List<Widget> drawOptions = [];
  List<TextEditingController> controllersList = [];
  String _opcionSeleccionada = 'Bool';
  List<String> _questionType = [
    'Bool',
    'Text',
    'Integer',
    'Float',
    'Check',
    'Multi Checker'
  ];
  bool requiredQuestion = false;
  bool _addQuestion = false;

  QuestionsModel questions = new QuestionsModel();
  final questionProvider = new QuestionProvider();
  final optionProvider = new OptionProvider();

  final _preguntaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    questions.question = '';
    questions.required = 0;
  }

  @override
  Widget build(BuildContext context) {
    final PollsModel poll =
        ModalRoute.of(context)!.settings.arguments as PollsModel;
    final pollsBloc = Provider.pollsBloc(context);
    pollsBloc.chargeUserPolls();
    final bloc = Provider.questionBloc(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${poll.pollReason}'),
        actions: [
          IconButton(
            icon: _addQuestion ? Icon(Icons.close) : Icon(Icons.add),
            onPressed: () => setState(() {
              questions.question = '';
              _preguntaController.clear();
              bloc.changePregunta('');
              _addQuestion = !_addQuestion;
            }),
          )
        ],
      ),
      body: Stack(
        children: [
          _questionsList(bloc),
          _makeQuestion(context, bloc),
        ],
      ),
    );
  }

  Widget _questionsList(QuestionBloc questionBloc) {
    final PollsModel poll =
        ModalRoute.of(context)!.settings.arguments as PollsModel;

    questionBloc.chargeQuestions(poll.id as int);

    return StreamBuilder(
        stream: questionBloc.questionStream,
        builder: (context, AsyncSnapshot<List<QuestionsModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) =>
                  _makeItem(context, questionBloc, snapshot.data![i]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _makeItem(BuildContext context, QuestionBloc questionBloc,
      QuestionsModel question) {
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: null,
        child: Column(
          children: [
            ListTile(
              title: Text('${question.question}'),
              subtitle: Text(
                  '${question.type} - ${question.required == 1 ? "respuesta obligatoria" : "respuesta opcional"}'),
              onTap: () => setState(() {
                questions.id = question.id;
                questions.question = question.question!;
                questions.required = question.required;
                _opcionSeleccionada = question.type!;
                _preguntaController.text = question.question!;
                questionBloc.changePregunta(question.question!);
                requiredQuestion = question.required == 1 ? true : false;
                _addQuestion = true;
              }),
            ),
            Divider(
              height: 0,
            )
          ],
        ));
  }

  Widget _makeQuestion(BuildContext context, QuestionBloc bloc) {
    final PollsModel poll =
        ModalRoute.of(context)!.settings.arguments as PollsModel;
    final size = MediaQuery.of(context).size;

    return _addQuestion
        ? Container(
            height: _definirAltura(size),
            margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            decoration: BoxDecoration(
                borderRadius: (BorderRadius.circular(20.0)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ]),
            child: Form(
                child: SingleChildScrollView(
              child: Column(
                children: [
                  _infoPollCard(poll),
                  // Divider(),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20.0),
                    child: Column(
                      children: [
                        _crearDropdown(),
                        SizedBox(height: 30),
                        _preguntaTextField(bloc),
                        SizedBox(height: 30),
                        _required(),
                        SizedBox(height: 10),
                        _changeBtn(poll, bloc)
                      ],
                    ),
                  ),
                ],
              ),
            )),
          )
        : Container();
  }

  Widget _infoPollCard(PollsModel poll) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: (BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
        // color: Color.fromRGBO(52, 211, 236, 0.4),
        color: Colors.black54,
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text('${poll.pollReason}',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.home_work_outlined, color: Colors.white),
              Text(' ${poll.pollSubtitle}',
                  style: TextStyle(color: Colors.white)),
              Expanded(child: Container()),
              Icon(Icons.poll_outlined, color: Colors.white),
              Text(' ${poll.expectedSamplings}',
                  style: TextStyle(color: Colors.white))
            ],
          )
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = [];

    _questionType.forEach((type) {
      lista.add(DropdownMenuItem(
        child: Text(type),
        value: type,
      ));
    });

    return lista;
  }

  Widget _crearDropdown() {
    questions.type = _opcionSeleccionada;
    return Row(
      children: [
        Text('Tipo:', style: TextStyle(fontSize: 18)),
        // Icon(Icons.tonality_sharp),
        Expanded(
          child: Container(),
        ),
        SizedBox(width: 30.0),
        DropdownButton(
          value: _opcionSeleccionada,
          items: getOpcionesDropdown(),
          onChanged: (value) {
            setState(() {
              _opcionSeleccionada = value as dynamic;
              questions.type = _opcionSeleccionada;
              if (_opcionSeleccionada != 'Multi Checker') drawOptions.clear();
            });
          },
        ),
      ],
    );
  }

  Widget _preguntaTextField(QuestionBloc bloc) {
    return StreamBuilder(
        stream: bloc.preguntaStream,
        builder: (context, snapshot) {
          return TextFormField(
            controller: _preguntaController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
              labelText: 'Pregunta **',
              helperText: 'Puede incluir signos',
              counterText: snapshot.data == null
                  ? ''
                  : snapshot.data.toString().length.toString(),
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onSaved: (value) => questions.question = value,
            onChanged: (value) {
              setState(() {
                questions.question = value;
              });

              bloc.changePregunta(value);
            },
          );
        });
  }

  Widget _required() {
    return CheckboxListTile(
      title: Text('¿Pregunta obligatoria?'),
      value: requiredQuestion,
      onChanged: (bool? valor) => setState(() {
        requiredQuestion = valor!;
        questions.required = requiredQuestion ? 1 : 0;
      }),
    );
  }

  Widget _optional(QuestionBloc bloc) {
    if (_opcionSeleccionada != "Multi Checker") return Container();

    final children = <Widget>[];

    children.addAll(drawOptions);

    return Column(
      children: children,
    );
  }

  double _definirAltura(Size size) {
    if (_opcionSeleccionada == "Multi Checker") {
      return size.height * 0.8;
    }

    return size.height * 0.63;
  }

  Widget _btnSaveQuestion(QuestionBloc bloc) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0))),
      ),
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 20),
          child: Icon(Icons.save_outlined)),
      onPressed:
          questions.question!.length < 4 ? null : () => _saveQuestionDB(bloc),
    );
  }

  Widget _changeBtn(PollsModel poll, QuestionBloc bloc) {
    if (_opcionSeleccionada != 'Multi Checker') return _btnSaveQuestion(bloc);

    return Column(
      children: [
        Divider(),
        SizedBox(height: 10),
        Text('Opciones adicionales', textAlign: TextAlign.left),
        SizedBox(height: 20),
        _optional(bloc),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0))),
              ),
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  child: Icon(Icons.add)),
              onPressed: () {
                TextEditingController optionController =
                    new TextEditingController();

                controllersList.add(optionController);
                drawOptions.add(_createOption(optionController));
                setState(() {});
              },
            ),
            Container(width: 20.0),
            _btnSaveQuestion(bloc),
          ],
        ),
      ],
    );
  }

  Widget _createOption(TextEditingController optionController) {
    return Column(
      children: [
        TextFormField(
          controller: optionController,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
            labelText: 'Opcion',
          ),
          // onSaved: (value) => bloc.controllerIn.add(value.toString()),
          // onChanged: (value) => bloc.controllerIn.add(value.toString()),
        ),
        Container(height: 20)
      ],
    );
  }

  _saveQuestionDB(QuestionBloc bloc) async {
    final PollsModel poll =
        ModalRoute.of(context)!.settings.arguments as PollsModel;

    final infoQuestion;
    final List<String> _options = [];
    // controllersList.addAll(options.values);

    controllersList.forEach((element) => _options.add(element.text));

    if (questions.id == null) {
      infoQuestion =
          await questionProvider.saveQuestion(poll.id!, questions, _options);

      if (infoQuestion!['success']) {
        await optionProvider.saveOptions(
            infoQuestion['data']['id'] as int, _options);

        setState(() {
          questions.id = null;
          questions.question = '';
          questions.required = 0;
          _preguntaController.clear();
          requiredQuestion = false;
          _options.clear();
          controllersList.clear();
          drawOptions.clear();

          // questions.required = 0;
        });

        mostrarSnackbar('Pregunta agregada!', true);
      } else {
        mostrarSnackbar('Error al guardar la pregunta', false);
      }
    } else {
      infoQuestion =
          await questionProvider.updateQuestion(poll.id!, questions, _options);

      if (infoQuestion!['success']) {
        setState(() {
          questions.id = null;
          questions.question = '';
          questions.required = null;
          _preguntaController.clear();
          requiredQuestion = false;
          // questions.required = 0;
          _addQuestion = false;
        });
        mostrarSnackbar('Pregunta actualizada!', true);
      } else {
        mostrarSnackbar('Error al actualizar la pregunta', false);
      }
    }
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
