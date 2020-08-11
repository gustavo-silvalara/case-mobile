import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movietta/app/pages/home/home_controller.dart';
import 'package:movietta/app/shared/models/movie_model.dart';
import 'package:movietta/app/widgets/movie_card_widget.dart';
import 'package:movietta/app/widgets/white_text_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Modular.get<HomeController>();

  List<MovieModel> list = [];
  int initialPage = 0;

  TextEditingController textEditingController = TextEditingController();

  bool isSearch = false;

  @override
  Widget build(BuildContext context) {
    var textField = TextFormField(
      controller: textEditingController,
      autofocus: true,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
          hintStyle: TextStyle(color: Colors.white70), hintText: 'Search'),
      onFieldSubmitted: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        homeController.title = textEditingController.text;
        setState(() {
          list = [];
          isSearch = false;
        });
        textEditingController.text = '';
        homeController.fetchMovies();
        currentFocus.unfocus();
      },
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: isSearch
            ? textField
            : Text(
                'MOVITTA',
                style: GoogleFonts.viga(
                    color: Colors.deepPurple, fontSize: 30, letterSpacing: 1),
              ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              setState(() {
                isSearch = isSearch ? false : true;
              });
            },
            icon: Icon(isSearch ? Icons.close : Icons.search),
          ),
        ],
      ),
      backgroundColor: Colors.black87,
      body: Observer(
        builder: (_) {
          if (homeController.movies.error != null) {
            return Center(
              child: WhiteText(
                text: ':(',
                fontSize: 50,
              ),
            );
          }
          if (homeController.movies.value == null) {
            return Center(
              child: SpinKitWanderingCubes(
                color: Colors.deepPurple,
              ),
            );
          }
          list.addAll(homeController.movies.value);
          return Center(
            child: CarouselSlider(
              options: CarouselOptions(height: 600.0),
              items: list.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return MovieCard(i);
                  },
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        child: GestureDetector(
          child: Icon(
            Icons.keyboard_arrow_right,
            size: 70,
            color: isSearch ? Colors.transparent : Colors.white,
          ),
          onTap: () {
            if (!isSearch) {
              initialPage = list.length - 1;
              homeController.fetchMore();
            }
          },
        ),
      ),
    );
  }
}

// Modular.to.pushNamed('/detail');
