import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pontabac/configquizz.dart';
import 'package:pontabac/quizzclass.dart';
import 'package:pontabac/quizzcommons.dart';

// Quizz orienté Album 33 T
// Ce sont pas des  cases dse pagers d'albums mais des  vers de chansons de BD

//ALBUMSARDOU

//GAMEQUIZZBD
//SARDOUBD

class QuizzZizik extends StatefulWidget {
  const QuizzZizik({Key? key}) : super(key: key);

  @override
  State<QuizzZizik> createState() => _QuizzZizikState();
}

class _QuizzZizikState extends State<QuizzZizik> {
  bool booldisplayCase = false;
  bool booldisplayHelp = false;
  bool booldisplayListAlbumRand = false;
  bool boolScore = false;
  bool boolZoom = true;
  bool chronoStart = false;
  bool countDown = true;
  bool createGameQuizzBdState = false;
  bool quizzOver = true;
  bool readAlbumMzState = false;
  bool readAlbumsCoversState = false;
  bool readBdSardouState = false;

  bool readGameQuizzScoresState = false;
  bool timeOut = false;
  bool updateGameQuizzBdState = false;
  Color colorCounter = Colors.green;

  double formeImage = 0.0;
  Duration countdownDuration = const Duration(seconds: 10000);
  Duration duration = const Duration();

  int activeQuizz = SARDOU; //   <tintin=1>
  int forceQuizz = 2;
  int gameNote = 0;
  int maxSuiteMax = 0;
  int nbGood = 0;
  int nbQuizz = 0;
  int random = 1;
  int recordQuizz = 0;
  int thisGameId = 0;
  int timeQuizzInitial = 60;
  int timerQuizz = 0;
  int totalSeconds = 60;

  List<AlbumMz> listAlbumBd = [];
  List<AlbumMz> listAlbumMz = [];
  List<AlbumMz> listAlbumRand = [];
  GameHistoric thisGameHistoric = GameHistoric(8, 1, 2, []);
  List<GameHistoric> listGameHistoric = [];
  List<GameQuizz> listMyGames = [];
  List<GameQuizzScores> listGameQuizzScores = [];
  List<PhotoBd> listPhotoBase = [];
  List<PhotoBd> listSardouCase = [];
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
                visible: quizzOver,
                child: ElevatedButton(
                  onPressed: () => {incForce()},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      textStyle: const TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          backgroundColor: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  child: Text("   Coeff: " + forceQuizz.toString()),
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
                          fontSize: 20,
                          color: Colors.red,
                          backgroundColor: Colors.blue,
                          fontWeight: FontWeight.bold)),
                  // gameNote = nbGood * (forceQuizz - 1);
                  child: Text(
                      "-->" + (nbGood * (forceQuizz - 1)).toString() + "Pts"),

                ),
              ),
              Visibility(
                  visible: quizzOver,
                  child: IconButton(
                      icon: const Icon(Icons.tv),
                      iconSize: 30,
                      color: Colors.greenAccent,
                      tooltip: 'Les Mentions',
                      onPressed: () {
                        setState(() {
                          boolScore = !boolScore;
                          booldisplayHelp=!boolScore;
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
                          booldisplayHelp = !booldisplayHelp;
                          boolScore=!booldisplayHelp;
                        });
                      })),
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

  void checkQuizz(indexalbum) {
    if (quizzOver) return;
    int successQuizz = (forceQuizz - 1) + 2;
    setState(() {
      nbQuizz++;
      // Update Historic

      thisGameHistoric.thatinode = listPhotoBase[random].photoinode;
      thisGameHistoric.goodbd = listPhotoBase[random].photoalbum;
      thisGameHistoric.bdreponse = indexalbum;
      listGameHistoric.add(thisGameHistoric);

      //
      thisGameHistoric = GameHistoric(8, 1, 2, []);

      if ((indexalbum) == listPhotoBase[random].photoalbum) {
        nbGood++;
        recordQuizz = recordQuizz + successQuizz;
      } else {
        recordQuizz = recordQuizz - 1;
      }
      majAlbumRand(); //

      while ((getRandomPlus()) == 1) {}
    });
  }

  Future createGameQuizzBd() async {
    createGameQuizzBdState = false;

    Uri url = Uri.parse(pathPHP + "createGAMEQUIZZBD.php");

    var data = {
      "THATBD": listBD[activeQuizz].bdThis,
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

      majAlbumRand(); // Set d'albums New
      while ((getRandomPlus()) == 1) {}
    }
  }

  Expanded displayCase() {
    if (!readBdSardouState) {
      return Expanded(
        child: Column(
          children: const [
            (Text('Wait Wait')),
          ],
        ),
      );
    }
    return Expanded(
        child: (GestureDetector(
            onTap: () => {
                  setState(() {
                    boolZoom = !boolZoom;
                  })
                },
            child: Stack(
              children: <Widget>[
                // Stroked text as border.
                Text(
                  listPhotoBase[random].photouploader,
                  style: TextStyle(
                    fontSize: 20,
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 6
                      ..color = Colors.blue[700]!,
                  ),
                ),
                // Solid text as fill.
                Text(
                  listPhotoBase[random].photouploader,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ))));
  }

  Row displayGame() {
    return (Row(children: <Widget>[
      Align(child: buildTime()),
      displayCase(),
      displayListAlbumRand(),
    ]));
  }

  Row displayHelp() {
    return

      Row(children: [
      Visibility(
        visible: booldisplayHelp,
        child:


          Image.network(
            "upload/helpsardou.png",
            /*
             width: 800,
             height: 1000,*/
          ),

      ),
    ]);
  }

  Widget displayListAlbumRand() {
    // On N'affiche pas si
    if (!readAlbumMzState || listAlbumRand.isEmpty) {
      return (dispQuizzScores());
    }
    if (quizzOver && boolScore) {
      return (dispQuizzScores());
    }

    var listView = ListView.builder(
        itemCount: listAlbumRand.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Column(
                children: [
                  Image.network(
                    "upload/" + listAlbumRand[index].albumcode + ".jpg",
                    width: forceQuizz >= 4 ? 128 : 192,
                    height: forceQuizz >= 4 ? 128 : 192,
                  ),
                  Text(
                    listAlbumRand[index].albumname,
                    style: TextStyle(
                        color: Colors.red,
                        fontStyle: FontStyle.normal,
                        fontSize: 10),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  if (!quizzOver) {
                    int indexOrigine = listAlbumRand[index].albumid;
                    checkQuizz(indexOrigine);
                  }
                });
              });
        });
    return Visibility(visible: boolZoom, child: (Expanded(child: listView)));
  }

  Row displayNoGame() {
    return (Row(children: <Widget>[
      //    booldisplayHelp:displayHelp() ?dispQuizzScores(),
      booldisplayHelp ? displayHelp() : dispQuizzScores(),
      !booldisplayHelp ? dispQuizzScores() : displayHelp(),
    ]));
  }

  Expanded dispQuizzScores() {
    if (!readGameQuizzScoresState || !boolScore) {
      return (const Expanded(child: Text(" ")));
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
                    "->" +
                    listGameQuizzScores[index].gamer.toString() +
                    " avec " +
                    listGameQuizzScores[index].gamescore.toString() +
                    " Pts",
                style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 10),
              ),
              subtitle: Text(
                " <" +
                    listGameQuizzScores[index].gamenbgood.toString() +
                    "/" +
                    listGameQuizzScores[index].gamenbquest.toString() +
                    "> " "Coeff=" +
                    listGameQuizzScores[index].gameforce.toString(),
                style: TextStyle(
                    fontSize: 10, fontFamily: 'Serif', color: Colors.black),
              ),
              onTap: () {
                setState(() {});
              });
        });
    return (

        Expanded(child: listView)
    );
  }

  int getRandomPlus() {
    // <PML>
    int errorRandom = 0;
    random = Random().nextInt(listPhotoBase.length);
// Trop Petit
// Trop Court
    if (listPhotoBase[random].photofilesize < 20) {
      errorRandom = 1;
      return (errorRandom);
    }
    //  Maintenant  Verifions que Random appartient ) la liste
    for (AlbumMz _album in listAlbumRand) {
      if (_album.albumid == listPhotoBase[random].photoalbum) {
        formeImage = listPhotoBase[random].photowidth /
            listPhotoBase[random].photoheight;
        int ratioImage = (10 * formeImage).toInt();
        formeImage = ratioImage / 10;
// Ici C'est OK il appartient à la lastre
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
    activeQuizz = SARDOU; // SArdou
    readBdSardou();
    readAlbumMz();

    recordQuizz = 0;
    quizzOver = true;
    totalSeconds = 60;
    nbQuizz = 0;
    nbGood = 0;
    thisGameId = 0;

    readGameQuizzScores();
  }

  double log10(num x) => log(x) / ln10;

  void majAlbumRand() {
    //this.bdNb, 22 albums
    //   a partie de cer Tome  this.bdFirst,
    // Initialisation  non prend  bdNb  albums depuis bdFirst
    //<PML> <TOIMPROVE>
    int _nbElem = listBD[activeQuizz].bdLast - listBD[activeQuizz].bdFirst + 1;
    int _startAlbum = listBD[activeQuizz].bdFirst; //+1 ??
    var albumRandList = List.generate(_nbElem, (i) => i + _startAlbum);
    var albumsList = List.generate(_nbElem, (i) => i + _startAlbum);
    // Ne prendre les albums dispo

// Liste aleatoire  de n nombres  parmi une liste de départ
    int p = (forceQuizz - 1) + 1; // de 0 à p-1
    albumsList.shuffle();
    albumRandList.clear(); // Numéros
    albumRandList = albumsList.sublist(0, p);
    // Historic
    thisGameHistoric.bdquizz = albumRandList;
    // On  utilise cette liste pour extraire les Albums
    //correspondant  de listAlbumBd)
    listAlbumRand.clear();
// listAlbumBd   liste des Albums direct MYSQL
    for (int i = 0; i < p; i++) {
      for (AlbumMz _album in listAlbumMz) {
        if (_album.albumid == albumRandList[i]) {
          listAlbumRand.add(_album);
        }
      }
    }
  }

  Future readAlbumMz() async {
    Uri url = Uri.parse(pathPHP + "readALBUMSMZ.php");
    readAlbumMzState = false;
    var data = {
      "BDNAME": "ALBUMSARDOU",
    };

    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listAlbumMz =
            datamysql.map((xJson) => AlbumMz.fromJson(xJson)).toList();
        readAlbumMzState = true;
      });
    } else {}
  }

  Future readBdSardou() async {
    Uri url = Uri.parse(pathPHP + "readBD.php");
    readBdSardouState = false;
    var data = {"BDSTORY": "SARDOUBD"};
    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listSardouCase =
            datamysql.map((xJson) => PhotoBd.fromJson(xJson)).toList();
        readBdSardouState = true;
        listSardouCase
            .sort((a, b) => a.photofilename.compareTo(b.photofilename));
      });

      setThema(SARDOU); // On met tintin par defaut
    } else {}
  }

  Future readGameQuizzScores() async {
    Uri url = Uri.parse(pathPHP + "readGAMEQUIZZSCORES.php");
    readGameQuizzScoresState = false;
    var data = {"THATBD": "SARDOU"};
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
    // Calcul des Points
    _scoreQuizz = 0.0;
    for (int j = 1; j <= maxSuiteMax; j++) {
      if (consList[j] > 0) {
        _scoreQuizz = _scoreQuizz + log10(consList[j]) + j * log10(forceQuizz);
      }
    }
    //        int ratioImage = (10 * formeImage).toInt();
    gameNote = nbGood * (forceQuizz - 1);
    recordQuizz = (_scoreQuizz * 100).toInt();
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

    //   readAlbumsCovers();
    // readBd();
    listPhotoBase.clear;
    listAlbumBd.clear;
    if (_thatBd == SARDOU) {
      listPhotoBase = listSardouCase;
      // listAlbumBd = listAlbumMz;//<PML>
    }

    recordQuizz = 0;
    quizzOver = true; //  On ne paut modifier en coirs de Game
    totalSeconds = 60;
    nbQuizz = 0;
    nbGood = 0;
    thisGameId = 0;

    setState(() {
      random = Random().nextInt(listSardouCase.length - 1); //<PML> pas sur
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
      "GAMESCORE": recordQuizz.toString(),
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
