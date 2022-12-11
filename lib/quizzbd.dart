import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pontabac/configquizz.dart';
import 'package:pontabac/quizzclass.dart';
import 'package:pontabac/quizzcommons.dart';

class QuizzBd extends StatefulWidget {
  const QuizzBd({Key? key}) : super(key: key);

  @override
  State<QuizzBd> createState() => _QuizzBdState();
}

class _QuizzBdState extends State<QuizzBd> {
  bool readTintinCoversState = false;
  bool readAsterixCoversState = false;
  bool readBdAsterixState = false;
  bool readBdTintinState = false;
  bool boolInit = false;
  bool quizzOver = true;
  bool readBdState = false;
  bool updateGameQuizzBdState = false;
  bool createPhotoBaseState = false;
  bool boolZoom = true;
  bool createGameQuizzBdState = false;
  bool getNewGameState = false;
  bool readAlbumsCoversState = false;
  bool readGameQuizzScoresState = false;
  int random = 1;
  int recordQuizz = 0;
  int forceQuizz = 2;
  int thisGameId = 0;
  int activeQuizz = 2; // <Asterix=2 >  <tintin=1>
  int gameNote=0;
  // Eviter les A/R avec Mysql
  // A faire au départ


  int newNote = 0;
  bool quizzHit = true;
 bool  booldisplayHelp = true;

  List<PhotoBd> listTintinCase = [];
  List<PhotoBd> listAsterixCase = [];
  List<AlbumBd> listTintinCover = [];
  List<AlbumBd> listAsterixCover = [];

  List<PhotoBd> listPhotoBase = [];
  List<AlbumBd> listAlbumBd = [];
  List<AlbumBd> listAlbumRand = [];
  List<GameQuizz> listMyGames = [];
  GameHistoric thisGameHistoric = GameHistoric(8, 1, 2, []);
  List<GameHistoric> listGameHistoric = [];
  List<GameQuizzScores> listGameQuizzScores = [];
  int cetAlbum = 1;
  int cettePage = 1;
  int cetteCase = 0;
  int nbQuizz = 0;
  int nbGood = 0;

  bool chronoStart = false;
  Duration countdownDuration = const Duration(seconds: 10000);
  int timerQuizz = 0;
  bool timeOut = false;

  int totalSeconds = 60;
  int timeQuizzInitial = 60;
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = true;
  Color colorCounter = Colors.green;

  double formeImage = 0.0;
  double coeffSize = 1.0;

  String reportInode = "";
  String reportAnswer = "";
  String reportQuizz = "";
  String reportGoodbd = "";
  String startButton = "Start";
  int maxSuiteMax = 0;

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
                  child: Text("Coeff: " + forceQuizz.toString()),
                ),
              ),
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
                child: Text(
                    "[N°" +
                        thisGameId.toString() +
                        "] :" +
                        totalSeconds.toString() +
                        's',
                    style: TextStyle(
                        color: (totalSeconds < 10) ? Colors.red : Colors.white,
                        fontSize: 15)),
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
                  child: Text("Force=" + forceQuizz.toString()),
                ),
              ),
            ],
          ),
        ),
      ]),
      body: Row(children: <Widget>[
        Align(child: buildTime()),
        displayCase(),
        displayListAlbumRand(),
      ]),
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
      setThema(1);
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
        newNote = newNote + (forceQuizz - 1);
        recordQuizz = recordQuizz + successQuizz;
      } else {
        recordQuizz = recordQuizz - 1;
        newNote = newNote -1;
      }
      majAlbumRand(); //
      //  int cava = 1; //check
      while ((getRandomPlus()) == 1) {}
    });
  }

  Future createGameQuizzBd() async {
    createGameQuizzBdState = false;
    getNewGameState = false;

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
        getNewGameState = true;
        thisGameId = listMyGames[0].gameid;
      });

      //  listGameHistoric.clear();
      majAlbumRand(); // Set d'albums New

      while ((getRandomPlus()) == 1) {}
    }
  }

  Expanded displayCase() {
    if (!readBdTintinState || !readBdAsterixState) {
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
      child: Image.network(
        "upload/" +
            listPhotoBase[random].photofilename +
            "." +
            listPhotoBase[random].photofiletype,
        //fit: BoxFit.cover,
        fit: BoxFit.contain,
      ),
    )));
  }

  Widget displayListAlbumRand() {
    if (!readAsterixCoversState || !readTintinCoversState) {
      //dispQuizzScores()
      return (dispQuizzScores());
      //    return (const Expanded(child: Text("Patientez Wait")));
    }
    if (quizzOver) {
      return (dispQuizzScores());
      //return (const Expanded(child: Text(" Press Start")));
    }

    var listView = ListView.builder(
        itemCount: listAlbumRand.length,
        controller: ScrollController(),
        itemBuilder: (context, index) {
          return ListTile(
              dense: true,
              title: Row(
                children: [
                  Image.network(
                    "upload/" + listAlbumRand[index].covername + ".jpg",
                    width: forceQuizz >= 3 ? 64 : 96,
                    height: forceQuizz >= 1 ? 86 : 128,
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

  Expanded dispQuizzScores() {
    if (!readGameQuizzScoresState) {
      return (const Expanded(child: Text(".............")));
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
                    " <Niveau=" +
                    listGameQuizzScores[index].gameforce.toString() +
                    ">",
                style: TextStyle(
                    fontFamily: 'Lobster',
                    color: Colors.black,
                    fontStyle: FontStyle.normal,
                    fontSize: 15),
              ),
              /*subtitle: Text(
                "Coeff=" +
                    listGameQuizzScores[index].gameforce.toString() +
                    " " +
                    " Max=" +
                    listGameQuizzScores[index].gamemax.toString() +
                    " <" +
                    listGameQuizzScores[index].gamenbgood.toString() +
                    "/" +
                    listGameQuizzScores[index].gamenbquest.toString() +
                    ">"+ " Noteplus = "+listGameQuizzScores[index].gamescore.toString(),

                style: TextStyle(
                    fontSize: 8, fontFamily: 'Serif', color: Colors.red),
              ),*/
              onTap: () {
                setState(() {});
              });
        });
    return (Expanded(child: listView));
  }

  int getRandomPlus() {
    // <PML>
    int errorRandom = 0;
    random = Random().nextInt(listPhotoBase.length);
    //  LE 1 est lié à Tintin soviets

/*    if (listPhotoBase[random].photoalbum == 1) {
      errorRandom = 1;
      return (errorRandom);
    }*/
// Trop Petit

    if (listPhotoBase[random].photofilesize < 20) {
      errorRandom = 1;
      return (errorRandom);
    }
    //  Maintenant  Verifions que Random appartient ) la liste
    for (AlbumBd _album in listAlbumRand) {
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

    boolInit = false;
    activeQuizz = 1;

    readBdTintin();
    readBdAsterix();

    readAsterixCovers();
    readTintinCovers();

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
      for (AlbumBd _album in listAlbumBd) {
        if (_album.albumid == albumRandList[i]) {
          listAlbumRand.add(_album);
        }
      }
    }
  }

  Future readAsterixCovers() async {
    Uri url = Uri.parse(pathPHP + "readALBUMSCOVERS.php");
    readAsterixCoversState = false;
    var data = {
      "BDNAME": "ALBUMSASTERIX",
    };

    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listAsterixCover =
            datamysql.map((xJson) => AlbumBd.fromJson(xJson)).toList();
        readAsterixCoversState = true;
      });
    } else {}
  }

  Future readBdAsterix() async {
    Uri url = Uri.parse(pathPHP + "readBD.php");
    readBdAsterixState = false;
    var data = {"BDSTORY": "ASTERIXBD"};
    http.Response response = await http.post(url, body: data);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        print("OK asterix");
        listAsterixCase =
            datamysql.map((xJson) => PhotoBd.fromJson(xJson)).toList();
        readBdAsterixState = true;
        listAsterixCase
            .sort((a, b) => a.photofilename.compareTo(b.photofilename));
      });
    } else {}
  }



  Future readBdTintin() async {
    Uri url = Uri.parse(pathPHP + "readBD.php");
    readBdTintinState = false;
    var data = {"BDSTORY": "TINTINBD"};
    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listTintinCase =
            datamysql.map((xJson) => PhotoBd.fromJson(xJson)).toList();
        readBdTintinState = true;
        listTintinCase
            .sort((a, b) => a.photofilename.compareTo(b.photofilename));
      });
      setThema(QuizzCommons.thatBac); // On met tintin par defaut
    } else {}
  }

  Future readGameQuizzScores() async {
    Uri url = Uri.parse(pathPHP + "readGAMEQUIZZSCORES.php");
    readGameQuizzScoresState = false;
    String _bede= "TINTIN";
    if (QuizzCommons.thatBac == TINTIN)  _bede= "TINTIN";
    if (QuizzCommons.thatBac == ASTERIX)  _bede= "ASTERIX";
    var data = {"THATBD": _bede};
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

  Future readTintinCovers() async {
    Uri url = Uri.parse(pathPHP + "readALBUMSCOVERS.php");
    readTintinCoversState = false;
    var data = {
      "BDNAME": "ALBUMSTINTIN",
    };

    http.Response response = await http.post(url, body: data);

    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listTintinCover =
            datamysql.map((xJson) => AlbumBd.fromJson(xJson)).toList();
        readTintinCoversState = true;

        listTintinCover = listTintinCover.sublist(1);
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
    gameNote=nbGood*(forceQuizz-1);
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
    activeQuizz = _thatBd; // <Asterix=2 >  <tintin=1>

    //   readAlbumsCovers();
    // readBd();
    listPhotoBase.clear;
    listAlbumBd.clear;
    if (_thatBd == 1) {
      listPhotoBase = listTintinCase;
      listAlbumBd = listTintinCover;
    }
    if (_thatBd == 2) {
      listPhotoBase = listAsterixCase;
      listAlbumBd = listAsterixCover;
    }

    recordQuizz = 0;
    quizzOver = true; //  On ne paut modifier en coirs de Game
    totalSeconds = 60;
    nbQuizz = 0;
    nbGood = 0;
    thisGameId = 0;
    coeffSize = 1.0;
    if (_thatBd == 2) coeffSize = 1.5; // Les photos asterix sont petites
    setState(() {
      random = Random().nextInt(5000); //<PML> pas sur
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
