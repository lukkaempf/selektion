import 'package:flutter/material.dart';
import 'package:selektion/routes.dart';
import 'package:selektion/services/local_player_service.dart';
import 'package:selektion/widgets/analysis_card.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppbar(context),
        body: Column(
          children: [
            InkWell(
              splashColor: Colors.blue.withAlpha(30),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.analysisTop4Screen);
              },
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Text('Top4 Spieler'),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: FutureBuilder(
                  future: LocalDatabaseService.instance.getAllTeams(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Noch keine Teams.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return AnalysisCard(team: snapshot.data![index]);
                      },
                    );
                  }),
            ),
          ],
        ));
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
        title: const Text('Auswertung'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)));
  }
}
