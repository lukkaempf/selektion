import 'package:flutter/material.dart';
import 'package:selektion/model/player.dart';
import 'package:selektion/model/rating.dart';
import 'package:selektion/routes.dart';
import 'package:selektion/services/local_player_service.dart';
import 'package:selektion/widgets/custom_button.dart';

class RatingScreen extends StatefulWidget {
  final int teamId;
  final Player player;
  const RatingScreen({required this.teamId, required this.player, super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen> {
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isTop4 = widget.player.isTop4;
    _noteController.text = widget.player.note;

    return Scaffold(
      appBar: _buildAppbar(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: Column(
                  children: [
                    TextField(
                      controller: _noteController,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: 'Bemerkung hinzufügen',
                        border: InputBorder.none,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: CustomElevatedButton(
                        text: 'Speichern',
                        onPressed: () async {
                          if (_noteController.text != widget.player.note) {
                            await LocalDatabaseService.instance.addNoteToPlayer(
                                widget.teamId,
                                widget.player.number,
                                _noteController.text);

                            Navigator.popUntil(context, (route) {
                              return route.settings.name == AppRoutes.home;
                            });

                            Navigator.pushNamed(context, AppRoutes.teamScreen);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 70,
            ),
            CustomElevatedButton(
              text: 'Ungenügend',
              onPressed: () async {
                await LocalDatabaseService.instance.ratePlayer(widget.teamId,
                    widget.player.number, Rating.ungenduegend.name);

                Navigator.popUntil(context, (route) {
                  return route.settings.name == AppRoutes.home;
                });

                Navigator.pushNamed(context, AppRoutes.teamScreen);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevatedButton(
              text: 'Genügend',
              onPressed: () async {
                await LocalDatabaseService.instance.ratePlayer(
                    widget.teamId, widget.player.number, Rating.genuegend.name);

                Navigator.popUntil(context, (route) {
                  return route.settings.name == AppRoutes.home;
                });

                Navigator.pushNamed(context, AppRoutes.teamScreen);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevatedButton(
              text: 'Gut',
              onPressed: () async {
                await LocalDatabaseService.instance.ratePlayer(
                    widget.teamId, widget.player.number, Rating.gut.name);

                Navigator.popUntil(context, (route) {
                  return route.settings.name == AppRoutes.home;
                });

                Navigator.pushNamed(context, AppRoutes.teamScreen);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomElevatedButton(
              text: 'Sehr Gut',
              onPressed: () async {
                await LocalDatabaseService.instance.ratePlayer(
                    widget.teamId, widget.player.number, Rating.sehrgut.name);

                Navigator.popUntil(context, (route) {
                  return route.settings.name == AppRoutes.home;
                });

                Navigator.pushNamed(context, AppRoutes.teamScreen);
              },
            ),
            const Expanded(child: SizedBox()),
            CustomElevatedButton(
              isSelected: isTop4,
              text: 'Top4',
              onPressed: () async {
                await LocalDatabaseService.instance
                    .toggleIsTop4(widget.teamId, widget.player.number);

                Navigator.popUntil(context, (route) {
                  return route.settings.name == AppRoutes.home;
                });

                Navigator.pushNamed(context, AppRoutes.teamScreen);
              },
            ),
            const SizedBox(
              height: 100,
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppbar(BuildContext context) {
    return AppBar(
        title: const Text('Bewertung'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)));
  }
}
