import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:pontabac/configquizz.dart';
import 'package:pontabac/quizzclass.dart';
import 'package:pontabac/quizzcommons.dart';

class Vinyl extends StatefulWidget {
  const Vinyl({Key? key}) : super(key: key);

  @override
  State<Vinyl> createState() => _VinylState();
}

class _VinylState extends State<Vinyl> {
  bool booldisplayCase = false;
  bool booldisplayHelp = true;
  bool booldisplayListAlbumRand = false;
  bool boolScore = false;
  bool boolZoom = true;
  bool chronoStart = false;
  bool countDown = true;
  bool createGameQuizzBdState = false;
  bool quizzOver = true;

  bool readBdSingerState = false;
  bool quizzHit = true;
  bool readQuizzSongsState = false;
  bool readGameQuizzScoresState = false;
  bool timeOut = false;
  bool updateGameQuizzBdState = false;
  Color colorCounter = Colors.green;

  Duration countdownDuration = const Duration(seconds: 10000);
  Duration duration = const Duration();

  int activeQuizz = 0; //   <tintin=1>
  int forceQuizz = 2;
  int gameNote = 0;
  int maxSuiteMax = 0;
  int nbGood = 0;
  int nbQuizz = 0;
  int random = 1;

  int thisGameId = 0;
  int timeQuizzInitial = 60;
  int timerQuizz = 0;
  int totalSeconds = 60;
  int newNote = 0;

  GameHistoric thisGameHistoric = GameHistoric(8, 1, 2, []);
  List<GameHistoric> listGameHistoric = [];
  List<GameQuizz> listMyGames = [];
  List<GameQuizzScores> listGameQuizzScores = [];
  List<PhotoBd> listPhotoBase = [];
  List<PhotoBd> listSingerCase = [];
  List<QuizzSongs> listQuizzSongs = [];
  List<QuizzSongs> listQuizzSongsRand = [];
  List<bool> listQuizzSongsRandBool = [];
  String reportAnswer = "";
  String reportGoodbd = "";
  String reportInode = "";
  String reportQuizz = "";
  String startButton = "Start";
  Timer? timer;

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        timeOut = true;
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(actions: [
        Expanded(
          child: Row(
            children: [
              Visibility(
                  visible: quizzOver,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                    color: Colors.red,
                    tooltip: 'Quitter',
                    onPressed: () => {Navigator.pop(context)},
                  )),
              Visibility(
                visible: quizzOver,
                child: ElevatedButton(
                  onPressed: () => {startQuizz()},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.red,
                          fontWeight: FontWeight.bold)),
                  child: Text(startButton),
                ),
              ),
              Visibility(
                visible: chronoStart && totalSeconds < 9900 && !quizzOver,
                child: Text(totalSeconds.toString() + 's',
                    style: TextStyle(
                        color: (totalSeconds < 10) ? Colors.red : Colors.white,
                        fontSize: 20)),
              ),
              Visibility(
                visible: !quizzOver,
                child: ElevatedButton(
                  onPressed: () => {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      textStyle: const TextStyle(
                          fontSize: 25,
                          color: Colors.red,
                          backgroundColor: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  child: Text("             " + newNote.toString() + " Points"),
                ),
              ),
              Visibility(
                  visible: quizzOver,
                  child: IconButton(
                      icon: const Icon(Icons.tv),
                      iconSize: 30,
                      color: Colors.greenAccent,
                      tooltip: 'Classement',
                      onPressed: () {
                        setState(() {
                          boolScore = !boolScore;
                          booldisplayHelp = !boolScore;
                        });
                      })),
              Visibility(
                  visible: quizzOver,
                  child: IconButton(
                      icon: const Icon(Icons.help),
                      iconSize: 30,
                      color: Colors.greenAccent,
                      tooltip: 'Help',
                      onPressed: () {
                        setState(() {
                          boolScore = !boolScore;
                          booldisplayHelp = !boolScore;
                        });
                      })),
              Visibility(
                visible: quizzOver,
                child: ElevatedButton(
                  onPressed: () => {incForce()},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      textStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          backgroundColor: Colors.green,
                          fontWeight: FontWeight.bold)),
                  child: Text("Niveau=" + forceQuizz.toString()),
                ),
              ),
            ],
          ),
        ),
      ]),
      body: !quizzOver ? displayGame() : displayNoGame(),
    ));
  }

  buildTime() {
    if (quizzOver) return;
    setState(() {
      totalSeconds = duration.inSeconds;
      if (totalSeconds < 10) colorCounter = Colors.red;
    });
    if (totalSeconds < 1) {
      //  Prepare  quii chaines

      reportFigures();
      updateGameQuizzBd();
      stopTimer();
      quizzOver = true; // Ouui il est Terminé
      startButton = "Start";

      //  Navigator.pop(context);
      setThema(SARDOU);
    } else {
      quizzOver = false;
    }
  }

  void checkQuizz(indexalbum, indexobjet) {
    if (quizzOver) return;
    print("in checkQuizz N°1 =" + indexalbum.toString());
    setState(() {
      nbQuizz++;
      // Update Historic
      thisGameHistoric.thatinode = listPhotoBase[random].photoinode;
      thisGameHistoric.goodbd = listPhotoBase[random].photoalbum;
      thisGameHistoric.bdreponse = indexalbum;
      listGameHistoric.add(thisGameHistoric);

      //
      thisGameHistoric = GameHistoric(8, 1, 2, []);
      if ((indexalbum) == listPhotoBase[random].photophl) {
        nbGood++;
        listQuizzSongsRandBool[indexobjet] = true;
        newNote = newNote + (forceQuizz - 1);
      } else {
        newNote = newNote - 1;
        listQuizzSongsRandBool[indexobjet] = false;
      }
      print("in checkQuizz N°2 =" + indexalbum.toString());

      majSongRand(); //

      while ((getRandomSong()) == 1) {}
    });
  }

  Future createGameQuizzBd() async {
    createGameQuizzBdState = false;
    Uri url = Uri.parse(pathPHP + "createGAMEQUIZZBD.php");

    var _codeGame="SARDOU";

    if  (QuizzCommons.thatBac==4)  _codeGame="SARDOUT";
    if  (QuizzCommons.thatBac==5)  _codeGame="BREL";
    var data = {

      "THATBD": _codeGame,
      "GAMER": QuizzCommons.myPseudo,
      "GAMERID": QuizzCommons.myUid.toString(),
      "GAMEFORCE": forceQuizz.toString(),
      "GAMESCORE": "0",
      "GAMENBSEC": totalSeconds.toString(),
    };

    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      setState(() {
        createGameQuizzBdState = true;
      });

      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listMyGames =
            datamysql.map((xJson) => GameQuizz.fromJson(xJson)).toList();
        thisGameId = listMyGames[0].gameid;
      });

      booldisplayHelp = false;
      booldisplayListAlbumRand = true;
      boolScore = false;
      majSongRand(); //
      while ((getRandomSong()) == 1) {}
    }
  }

  Expanded displayCase() {
    quizzHit = false;
    if (!readBdSingerState) {
      return Expanded(
        child: Column(
          children: const [
            (Text('Wait Wait')),
          ],
        ),
      );
    }
    return Expanded(
        child: GestureDetector(
            onTap: () => {
                  setState(() {
                    //<PML> pas de zoom  pour du text
                    //  boolZoom = !boolZoom;
                  })
                },
            child: Container(
                alignment: Alignment.topLeft,
                child: Text(
                  listPhotoBase[random].photouploader,
                  textDirection: TextDirection.ltr,
                  style: GoogleFonts.pacifico(fontSize: 30),
                ))));
  }

  Row displayGame() {
    return (Row(children: <Widget>[
      Align(child: buildTime()),
      displayCase(),
      displayListQuizzSongsRand(),
    ]));
  }

  Row displayHelp() {
    return Row(children: [
      Visibility(
        visible: booldisplayHelp,
        child: Image.network(
          "upload/helpsardou.png",
        ),
      ),
    ]);
  }

  Widget displayListQuizzSongsRand() {
    if (!readQuizzSongsState || listQuizzSongsRand.isEmpty) {
      print(" Not Radis  yet");

      return (dispQuizzScores());
    }
    if (quizzOver && boolScore) {
      //    print (" quizzOver && boolScore");
      return (dispQuizzScores());
    }

    var listView = ListView.builder(
        itemCount: listQuizzSongsRand.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              leading: CircleAvatar(
                radius: 10.0,
                backgroundColor: listQuizzSongsRandBool[index]
                    ? Color(0xff764abc)
                    : Colors.green,
                child: Text("?"),
              ),
              title: Text(
                listQuizzSongsRand[index].songname,
                style: TextStyle(
                    color: Colors.red,
                    fontStyle: FontStyle.normal,
                    fontSize: 22),
              ),
              onTap: () {
                setState(() {
                  if (!quizzOver && !quizzHit) {
                    quizzHit = true;
                    int indexOrigine = listQuizzSongsRand[index].songid;
                    checkQuizz(indexOrigine, index);
                  }
                });
              });
        });
    return Visibility(visible: boolZoom, child: (Expanded(child: listView)));
  }

  Row displayNoGame() {
    return (Row(children: <Widget>[
      booldisplayHelp ? displayHelp() : dispQuizzScores(),
    ]));
  }

  Expanded dispQuizzScores() {
    if (!readGameQuizzScoresState || !boolScore) {
      return (const Expanded(child: Text(" Not Ready ")));
    }

    var listView = ListView.builder(
        itemCount: listGameQuizzScores.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Text(
                " N°" +
                    (index + 1).toString() +
                    ":" +
                    listGameQuizzScores[index].gamer.toString() +
                    "-->  " +
                    listGameQuizzScores[index].gamescore.toString() +
                    " Pts" +
                    " <" +
                    listGameQuizzScores[index].gameforce.toString() +
                    ">",
                style: TextStyle(
                    fontFamily: 'Lobster',
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 15),
              ),
              onTap: () {
                setState(() {});
              });
        });
    return (Expanded(child: listView));
  }

  int getRandomSong() {
    // <PML>
    int errorRandom = 0;
    setState(() {
      random = Random().nextInt(listPhotoBase.length);
    });

// Trop Court

    if (listPhotoBase[random].photofilesize < 8) {
      errorRandom = 1;
      return (errorRandom);
    }
    if (listPhotoBase[random].photowidth < 1) {
      // Les Doublons
      errorRandom = 1;
      return (errorRandom);
    }
    //  Maintenant  Verifions que Random appartient ) la liste
    //  Dans le principe   On regarde si la bonne réponse
    // fait partie de la selection aleatoire

    for (QuizzSongs _album in listQuizzSongsRand) {
      if (_album.songid == listPhotoBase[random].photophl) {
// Ici C'est OK il appartient à la lastre
        print("On a trouvé");
        thisGameHistoric.thatinode = listPhotoBase[random].photoinode;
        thisGameHistoric.goodbd = listPhotoBase[random].photoalbum;
        return (0);
      }
    }
    errorRandom = 1;
    return (errorRandom);
  }

  void incForce() {
    if (!quizzOver) return; // Securité
    setState(() {
      forceQuizz++;
      if (forceQuizz > 14) forceQuizz = 2;
    });
  }

  @override
  void initState() {
    super.initState();
   // activeQuizz = SARDOU; // SArdou
    activeQuizz= QuizzCommons.thatBac;
    readBdSinger();
    readQuizzSongs();

    quizzOver = true;
    totalSeconds = 60;
    nbQuizz = 0;
    nbGood = 0;
    thisGameId = 0;

    readGameQuizzScores();
  }

  void majSongRand() {
    //  Tirer au  Hasard  les Chansons
//
    int _nbElem = listBD[activeQuizz].bdLast - listBD[activeQuizz].bdFirst + 1;
    int _startAlbum = listBD[activeQuizz].bdFirst; //+1 ??
    // Pour les chansons
    _nbElem = listQuizzSongs.length;
    var randListObjects = List.generate(_nbElem, (i) => i + _startAlbum);
    var listObjects = List.generate(_nbElem, (i) => i + _startAlbum);

// Liste aleatoire  de n nombres  parmi une liste de départ
    int p = forceQuizz; // de 0 à p-1
    listObjects.shuffle();
    randListObjects.clear(); // Numéros
    randListObjects = listObjects.sublist(0, p);
    // Historic
    thisGameHistoric.bdquizz = randListObjects;
    // On  utilise cette liste pour extraire les

    listQuizzSongsRand.clear();
    listQuizzSongsRandBool.clear();
    for (int j = 0; j < p; j++) {
      listQuizzSongsRandBool.add(false);
    }

    print("randListObjects = " + randListObjects.length.toString());
    for (int i = 0; i < p; i++) {
      for (QuizzSongs _album in listQuizzSongs) {
        if (_album.songid == randListObjects[i]) {
          listQuizzSongsRand.add(_album);
        }
      }
    }
    print("listQuizzSongsRand ----> " + listQuizzSongsRand.length.toString());
  }

  Future readBdSinger() async {
    Uri url = Uri.parse(pathPHP + "readBD.php");
    readBdSingerState = false;
    var _singerBD="SARDOUBD";

    if  (QuizzCommons.thatBac==4)  _singerBD="SARDOUBD";
    if  (QuizzCommons.thatBac==5)  _singerBD="BRELBD";
    var data = {"BDSTORY": _singerBD};
    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listSingerCase =
            datamysql.map((xJson) => PhotoBd.fromJson(xJson)).toList();
        readBdSingerState = true;
        listSingerCase
            .sort((a, b) => a.photofilename.compareTo(b.photofilename));
      });

      setThema(SARDOU); // On met tintin par defaut
    } else {}
  }

  Future readGameQuizzScores() async {
    Uri url = Uri.parse(pathPHP + "readGAMEQUIZZSCORES.php");
    readGameQuizzScoresState = false;

    var _codeGame="SARDOU";

    if  (QuizzCommons.thatBac==4)  _codeGame="SARDOUT";
    if  (QuizzCommons.thatBac==5)  _codeGame="BREL";

    var data = {"THATBD":  _codeGame};
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listGameQuizzScores =
            datamysql.map((xJson) => GameQuizzScores.fromJson(xJson)).toList();
        readGameQuizzScoresState = true;

        listGameQuizzScores.sort((a, b) => b.gamescore.compareTo(a.gamescore));
      });
    } else {}
  }

  Future readQuizzSongs() async {
    Uri url = Uri.parse(pathPHP + "readQUIZZSONGLIMITED.php");
    readQuizzSongsState = false;
    var data = {
      "BDNAME": "BIDON",
    };

    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listQuizzSongs =
            datamysql.map((xJson) => QuizzSongs.fromJson(xJson)).toList();
        readQuizzSongsState = true;
        print(" listQuizzSongs=" + listQuizzSongs.length.toString());
      });
    } else {}
  }

  void reportFigures() {
    var consList = List.generate(nbQuizz + 1, (index) => 0);

    reportAnswer = "";
    reportInode = "";
    reportQuizz = "";
    reportGoodbd = "";

    double _scoreQuizz = 0;
    int maxSuite = 0;

    int lastgood = 0;
    maxSuiteMax = 0;

    for (GameHistoric _histo in listGameHistoric) {
      reportInode = reportInode + _histo.thatinode.toString() + ";";
      reportAnswer = reportAnswer + _histo.bdreponse.toString() + ";";
      reportGoodbd = reportGoodbd + _histo.goodbd.toString() + ";";
      if (_histo.bdreponse == _histo.goodbd) {
        maxSuite++; // Pour Optimiser
        if (maxSuite > maxSuiteMax) maxSuiteMax = maxSuite;
        lastgood = 1;
      } else {
        // Mauvaise réponse
        lastgood = 0;
        if (maxSuite > 0) {
          consList[maxSuite] = consList[maxSuite] + 1;
        }
        maxSuite = 0;
      }

      for (int j = 0; j < _histo.bdquizz.length; j++) {
        reportQuizz = reportQuizz + _histo.bdquizz[j].toString() + ";";
      }
    }
//
    if (lastgood == 1) {
      // Ne pas oublier le dernier  si on termine par ine bonne reponse
      if (maxSuite > maxSuiteMax) maxSuiteMax = maxSuite;
      consList[maxSuite] = consList[maxSuite] + 1;
    }

    gameNote = nbGood * (forceQuizz - 1);
  }

  void reset() {
    if (countDown) {
      setState(() => duration = countdownDuration);
      duration = countdownDuration;
    } else {
      setState(() => duration = const Duration());
    }
  }

  void setThema(int _thatBd) {
    activeQuizz = _thatBd; //    <tintin=1>
    listPhotoBase.clear;

    if (_thatBd == SARDOU) {
      listPhotoBase = listSingerCase;
    }

    quizzOver = true; //  On ne paut modifier en coirs de Game
    totalSeconds = 60;
    nbQuizz = 0;
    nbGood = 0;
    thisGameId = 0;
    setState(() {
      random = Random().nextInt(listSingerCase.length - 1); //<PML> pas sur
    });
  }

  void startQuizz() {
    listGameHistoric.clear(); //<PML>
    setState(() {
      chronoStart = true;
      timerQuizz = timeQuizzInitial;
      countDown = true;
      countdownDuration = Duration(seconds: timerQuizz);
      duration = Duration(seconds: timerQuizz);
      reset();
      startTimer();
      chronoStart = true;
      quizzOver = false;
      reportInode = "";
      startButton = totalSeconds.toString();
      newNote = 0;
      quizzHit = true;
      booldisplayHelp = true;
    });
    createGameQuizzBd();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }

  Future updateGameQuizzBd() async {
    updateGameQuizzBdState = false;
    Uri url = Uri.parse(pathPHP + "updateGAMEQUIZZBD.php");

    var data = {
      "GAMEID": thisGameId.toString(),
      "GAMESCORE": newNote.toString(),
      "GAMENBGOOD": nbGood.toString(),
      "GAMENBQUEST": nbQuizz.toString(),
      "GAMEMAX": maxSuiteMax.toString(),
      "GAMENOTE": gameNote.toString(),
      "LISTINODE": reportInode,
      "LISTANSWER": reportAnswer,
      "LISTGOODBD": reportGoodbd,
      "LISTQUIZZ": reportQuizz,
    };

    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      setState(() {
        updateGameQuizzBdState = true;
        // A ce niveau Afficher les Scores
        readGameQuizzScores();
      });
    }
  }
}
