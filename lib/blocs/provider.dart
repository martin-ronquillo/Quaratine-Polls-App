import 'package:flutter/material.dart';

// import 'package:polls_app/blocs/products_bloc.dart';
// export 'package:polls_app/blocs/products_bloc.dart';

import 'package:polls_app/blocs/login_bloc.dart';
import 'package:polls_app/blocs/option_Bloc.dart';
import 'package:polls_app/blocs/polls_bloc.dart';
import 'package:polls_app/blocs/question_bloc.dart';
export 'package:polls_app/blocs/login_bloc.dart';

class Provider extends InheritedWidget {
  final _loginBloc = new LoginBloc();
  final _pollsBloc = new PollBloc();
  final _questionBloc = new QuestionBloc();
  final _optionBloc = new OptionBloc();

  // final _productosBloc = new ProductosBloc();

  static Provider? _instancia;

  factory Provider({Key? key, required Widget child}) {
    if (_instancia == null) {
      _instancia = new Provider._internal(key: key, child: child);
    }
    return _instancia!;
  }

  Provider._internal({Key? key, required Widget child})
      : super(key: key, child: child);

  // Provider({Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!._loginBloc;
  }

  static PollBloc pollsBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!._pollsBloc;
  }

  static QuestionBloc questionBloc(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<Provider>()!
        ._questionBloc;
  }

  static OptionBloc optionBloc(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<Provider>()!._optionBloc;
  }
}
