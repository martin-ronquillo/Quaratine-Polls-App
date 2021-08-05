import 'package:flutter/material.dart';
import 'package:polls_app/blocs/polls_bloc.dart';
import 'package:polls_app/blocs/provider.dart';
import 'package:polls_app/models/polls_model.dart';

class UserPolls extends StatelessWidget {
  const UserPolls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pollsBloc = Provider.pollsBloc(context);
    // pollsBloc.chargeUserPolls();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis encuestas'),
        actions: [
          IconButton(
            icon: Icon(Icons.addchart_outlined, size: 25),
            onPressed: () => Navigator.pushNamed(context, 'create_poll'),
          )
        ],
      ),
      body: _pollsList(pollsBloc),
    );
  }

  Widget _pollsList(PollBloc pollBloc) {
    pollBloc.chargeUserPolls();

    return StreamBuilder(
        stream: pollBloc.pollsUserStream,
        builder:
            (BuildContext context, AsyncSnapshot<List<PollsModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, i) =>
                  _makeItem(context, pollBloc, snapshot.data![i]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _makeItem(BuildContext context, PollBloc pollBloc, PollsModel poll) {
    _submit() {
      Navigator.pushNamed(context, 'create_question', arguments: poll);
    }

    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: null,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.poll_outlined, size: 45),
              title: Text('${poll.pollReason}'),
              subtitle: Text(poll.pollSubtitle == null ? '${poll.id}' : '${poll.pollSubtitle} - ${poll.id}'),
              onTap: _submit,
            ),
            Divider(
              height: 0,
            )
          ],
        ));
  }
}
