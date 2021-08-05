import 'package:flutter/material.dart';
import 'package:polls_app/blocs/polls_bloc.dart';
import 'package:polls_app/blocs/provider.dart';
import 'package:polls_app/models/polls_model.dart';
import 'package:polls_app/providers/poll_provider.dart';
// import 'package:polls_app/user_preferences/user_preferences.dart';
import 'package:polls_app/utils/utils.dart';

class CreatePoll extends StatefulWidget {
  @override
  _CreatePollState createState() => _CreatePollState();
}

class _CreatePollState extends State<CreatePoll>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
  )..repeat(reverse: true);
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.03, 0.0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.bounceIn,
  ));

  @override
  dispose() {
    _controller.dispose(); // you need this
    super.dispose();
  }

  // final _prefs = new PreferenciasUsuario();
  PollsModel poll = new PollsModel();
  final pollProvider = new PollProvider();

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  bool _alert = true;

  // bool _guardando = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Nueva encuesta'),
      ),
      body: _pollForm(context),
    );
  }

  Widget _pollForm(BuildContext context) {
    final bloc = Provider.pollsBloc(context);
    //Se resetean los datos del stream cada vez que se ingresa al formulario
    // bloc.changeReason('');
    // bloc.changeSubtitle('');
    // bloc.chageSamplings('1');

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            SafeArea(child: Container(height: 20)),
            _alert == true
                ? SlideTransition(
                    position: _offsetAnimation,
                    child: Dismissible(
                      key: UniqueKey(),
                      child: _infoPoll(),
                      onDismissed: (direccion) =>
                          setState(() => _alert = false),
                    ))
                : Container(),
            SizedBox(height: 30),
            _pollReason(bloc),
            SizedBox(height: 30),
            _pollSubtitle(bloc),
            SizedBox(height: 30),
            _pollSamplings(bloc),
            // _infoPoll(),
            SizedBox(height: size.height * 0.1),
            _btnSavePoll(bloc),
          ],
        ),
      ),
    );
  }

  Widget _pollReason(PollBloc bloc) {
    return StreamBuilder(
      stream: bloc.reasonStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              suffixIcon:
                  Icon(Icons.family_restroom_sharp, color: Colors.deepPurple),
              border: OutlineInputBorder(),
              labelText: 'Razón social **',
              helperText: 'El titulo que se otorgara a la encuesta',
              counterText: snapshot.data == null
                  ? ''
                  : snapshot.data.toString().length.toString(),
              errorText:
                  snapshot.error != null ? snapshot.error.toString() : null,
            ),
            onSaved: (value) => poll.pollReason = value!,
            onChanged: (value) => bloc.changeReason(value),
          ),
        );
      },
    );
  }

  Widget _pollSubtitle(PollBloc bloc) {
    return StreamBuilder(
        stream: bloc.subtitleStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                suffixIcon: Icon(
                  Icons.subtitles,
                  color: Colors.deepPurple,
                ),
                border: OutlineInputBorder(),
                labelText: 'Subtitulo',
                helperText: 'Puede ser el nombre de la organizacion o empresa',
                counterText: snapshot.data == null
                    ? ''
                    : snapshot.data.toString().length.toString(),
                errorText:
                    snapshot.error != null ? snapshot.error.toString() : null,
              ),
              onSaved: (value) => poll.pollSubtitle = value!,
              onChanged: (value) => bloc.changeSubtitle(value),
            ),
          );
        });
  }

  Widget _pollSamplings(PollBloc bloc) {
    return StreamBuilder(
        stream: bloc.samplingStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.pie_chart_outline_outlined,
                      color: Colors.deepPurple),
                  border: OutlineInputBorder(),
                  labelText: 'Muestras totales **',
                  helperText: 'Representa la cantidad de encuestas esperadas',
                  errorText:
                      snapshot.error != null ? snapshot.error.toString() : null,
                ),
                onSaved: (value) =>
                    poll.expectedSamplings = int.tryParse(value!),
                onChanged: (value) => bloc.chageSamplings(value)),
          );
        });
  }

  Widget _infoPoll() {
    final size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color.fromRGBO(55, 255, 252, 0.4),
      ),
      height: 80,
      margin: EdgeInsets.symmetric(horizontal: 20.0),
      padding: EdgeInsets.all(20.0),
      child: Row(
        children: [
          Container(
              width: size.width * 0.7,
              child: Text('Los campos marcados con "**" son obligatorios',
                  style: TextStyle(fontSize: 16, color: Colors.black45))),
          Expanded(
            child: Container(),
          ),
          Icon(Icons.arrow_forward)
        ],
      ),
    );
  }

  Widget _btnSavePoll(PollBloc bloc) {
    return StreamBuilder(
        stream: bloc.formValidStream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0))),
                backgroundColor: snapshot.hasData
                    ? MaterialStateProperty.all(Colors.deepPurple)
                    : MaterialStateProperty.all(Colors.grey)),
            // onPressed:  snapshot.hasData ? () => _login(context, bloc) : null,
            onPressed: snapshot.hasData ? () => _submit() : null,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 70.0, vertical: 15.0),
                child: Text('Crear encuesta')),
          );
        });
  }

  _submit() async {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    final info = await pollProvider.savePoll(poll);

    if (info!['success'] == true) {
      PollsModel poll = new PollsModel();
      final datos = info['data'];
      poll.id = datos['id'];
      poll.userId = datos['user_id'];
      poll.pollReason = datos['poll_reason'];
      poll.pollSubtitle = datos['poll_subtitle'];
      poll.expectedSamplings = datos['expected_samplings'];
      poll.active = datos['active'];
      poll.updatedAt = datos['updated_at'];
      poll.createdAt = datos['created_at'];
      Navigator.pushReplacementNamed(context, 'create_question',
          arguments: poll);
    } else {
      mostrarAlerta(context, 'Error al crear la encuesta');
    }
  }
}
