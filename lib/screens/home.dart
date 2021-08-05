import 'package:flutter/material.dart';

import 'package:polls_app/blocs/polls_bloc.dart';
import 'package:polls_app/blocs/provider.dart';
import 'package:polls_app/models/polls_model.dart';
import 'package:polls_app/models/questions_model.dart';
import 'package:polls_app/providers/question_provider.dart';
import 'package:polls_app/search/search_delegate.dart';

class HomeScreen extends StatelessWidget {
  // final pollProvider = new PollProvider();
  final questionProvider = new QuestionProvider();
  final List<QuestionsModel> questionsList = [];

  @override
  Widget build(BuildContext context) {
    final pollsBloc = Provider.pollsBloc(context);
    pollsBloc.chargePolls();

    return Scaffold(
      appBar: AppBar(
        title: Text('DoPolls'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
              );
            },
          )
        ],
      ),
      drawer: _crearMenu(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.poll_outlined),
        onPressed: null,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomNavigation(),
      body: _pollsList(pollsBloc),
    );
  }

  Widget _pollsList(PollBloc pollBloc) {
    return StreamBuilder(
        stream: pollBloc.pollsStream,
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
    return Dismissible(
        key: UniqueKey(),
        background: Container(color: Colors.red),
        onDismissed: null,
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.poll_outlined, size: 45),
              title: Text('${poll.pollReason}'),
              subtitle: Text('${poll.pollSubtitle}'),
              onTap: () => {
                _getQuestions(poll).whenComplete(() => Navigator.pushNamed(
                    context, 'poll_answers',
                    arguments: {'poll': poll, 'questions': questionsList})),
              },
            ),
            Divider(
              height: 0,
            )
          ],
        ));
  }

  Future _getQuestions(PollsModel poll) async {
    questionsList.clear();
    final questions = await questionProvider.getQuestionsPolls(poll.id as int);

    questionsList.addAll(questions);
  }

  Drawer _crearMenu(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Container(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/menu-img.jpg'),
                    fit: BoxFit.cover)),
          ),
          ListTile(
            leading: Icon(Icons.poll_outlined, color: Colors.blue, size: 25),
            title: Text('Mis encuestas', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'user_polls');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.blue, size: 25),
            title: Text('Preferencias', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, 'user_pref');
            },
          ),
        ],
      ),
    );
  }
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      // selectedLabelStyle: TextStyle(color: Colors.white),
      selectedIconTheme: IconThemeData(color: Colors.cyanAccent),
      // selectedItemColor: Colors.cyanAccent,
      backgroundColor: Colors.deepPurple,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.poll_outlined, color: Colors.white),
          label: 'Encuestas',
        ),
        BottomNavigationBarItem(
            icon: Icon(Icons.gps_fixed_outlined), label: 'Mapas'),
        // BottomNavigationBarItem(
        //   icon: Icon(Icons.build_circle_outlined),
        //   label: 'Preferencias'
        // ),
      ],
    );
  }
}
