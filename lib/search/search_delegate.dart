import 'package:flutter/material.dart';
import 'package:polls_app/models/polls_model.dart';
import 'package:polls_app/providers/poll_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = '';

  final pollProvider = new PollProvider();

  final polls = [];

  final pollsRecurrents = [];

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar, ej: El icono de limpiar o cancelar busqueda
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Generalmente un icono a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados a mostrar
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Sugerencias que aparecen al escribir en la busqueda
    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: pollProvider.searchPoll(query),
      builder: (context, AsyncSnapshot<List<PollsModel>> snapshot) {

        if(snapshot.hasData) {

          final polls = snapshot.data;

          return ListView(
            children: polls!.map((poll) {
              return ListTile(
                title: Text('${poll.pollReason}'),
                subtitle: Text('${poll.pollSubtitle} - ${poll.id}'),
                onTap: () => {},
              );
            }).toList(),
          );

        } else  {

          return Center(
            child: CircularProgressIndicator(),
          );

        }
      }

    );
  }
}
