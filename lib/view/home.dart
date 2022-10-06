import 'dart:convert';
import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:learn_http/model/user.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  String? swipeDirection;

  Future<List<User>> _fetchData() async {
    var url = Uri.parse("https://jsonplaceholder.typicode.com/users");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List userJsonList = jsonDecode(response.body);
      return userJsonList
          .map((userJsonMap) => User.fromJSON(userJsonMap))
          .toList();
    } else {
      throw Exception("Erreur de chargement des données");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Requête https"),
      ),
      body: Center(
          child: FutureBuilder<List<User>>(
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ScrollablePositionedList.separated(
              physics: const NeverScrollableScrollPhysics(),
              itemScrollController: itemScrollController,
              itemPositionsListener: itemPositionsListener,
              initialScrollIndex: 9,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final user = snapshot.data![index];
                return GestureDetector(
                    onPanUpdate: (details) {
                      swipeDirection = details.delta.dx < 0 ? 'left' : 'right';
                    },
                    onPanEnd: (details) {
                      if (swipeDirection == null) {
                        return;
                      }
                      if (swipeDirection == 'left') {
                        if (index < snapshot.data!.length - 1) {
                          setState(() {
                            index += 1;
                            itemScrollController.scrollTo(
                                index: index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInCubic);
                          });
                        }
                      }
                      if (swipeDirection == 'right') {
                        // no before today
                        if (index > 0) {
                          setState(() {
                            index -= 1;
                            itemScrollController.scrollTo(
                                index: index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInSine);
                          });
                        }
                      }
                    },
                    child: Container(
                        color: Theme.of(context).primaryColor,
                        margin: const EdgeInsets.all(10),
                        width: width,
                        child: Column(
                          children: [
                            Text(
                              user.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(color: Colors.red),
                            ),
                            Text(user.city)
                          ],
                        )));
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: snapshot.data!.length,
            );
          } else if (snapshot.hasError) {
            return const Text("Erreur de chargement");
          } else {
            return const CircularProgressIndicator();
          }
        }),
        future: _fetchData(),
      )),
    );
  }
}
