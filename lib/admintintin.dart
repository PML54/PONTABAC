import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pontabac/configquizz.dart';
import 'package:pontabac/quizzclass.dart';

class AdminTintin extends StatefulWidget {
  const AdminTintin({Key? key}) : super(key: key);

  @override
  State<AdminTintin> createState() => _AdminTintinState();
}

class _AdminTintinState extends State<AdminTintin> {
  bool getPhotoCatState = false;
  bool getPhotoBaseState = false;
  bool isAdminConnected = false;
  bool boolCategory = false;
  bool createPhotoBaseState = false;
  int getPhotoCatError = -1;
  int nbPhotoCat = 0;
  int getPhotoBaseError = -1;
  bool getTintinAlbumsState = false;
  List<PhotoTintin> listPhotoBase = [];
  List<PhotoTintin> listPhotoBaseWork = [];
  List<AlbumTintin> listAlbumTintin = [];
  List<Icon> selIcon = [];
  Icon catIcon = const Icon(Icons.remove);
  int nbPhotoRandom = 0;
  int cestCeluiLa = 0;
  int cetAlbum = 1;
  int cettePage = 1;
  int cetteCase = 0;
  bool lockPhotoState = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(actions: <Widget>[
        Visibility(
          visible: true,
          child: Expanded(
            child:

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [

                IconButton(
                    icon: const Icon(Icons.close),
                    iconSize: 12,
                    color: Colors.red,
                    tooltip: 'Quitter',
                  onPressed: () => {Navigator.pop(context)},

                    ),
                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 12,
                    color: Colors.red,
                    tooltip: 'Prev Page',
                    onPressed: () {
                      prevPage();
                    }),
                IconButton(
                    icon: const Icon(Icons.last_page),
                    iconSize: 10,
                    color: Colors.black,
                    tooltip: 'Derniere Page',
                    onPressed: () {
                      lastPage();
                    }),
                ElevatedButton(
                    onPressed: () => {nextPage()},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,

                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            backgroundColor: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    child:  Text("Page "+ cettePage.toString()  )),
                ElevatedButton(
                    onPressed: () => { nextCase()},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,

                        textStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            backgroundColor: Colors.blue,
                            fontWeight: FontWeight.bold)),
                    child:  Text("Case "+ cetteCase.toString()  )),


                IconButton(
                    icon: const Icon(Icons.arrow_back),
                    iconSize: 10,
                    color: Colors.blue,
                    tooltip: 'Case Précédente',
                    onPressed: () {
                      prevCase();
                    }),




              ],
            ),

          ),
        ),
      ]),
      body: SafeArea(
        child: Column(children: <Widget>[
          ElevatedButton(
              onPressed: () => {nextAlbum()},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,

                  textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      backgroundColor: Colors.blue,
                      fontWeight: FontWeight.bold)),
              child: Text(listAlbumTintin[cetAlbum-1].albumname)),
          getget(),
        ]),
      ),
    ));
  }

  cleanTintinAlbums() {
    // Page de 1 à n
    // Case de 0 à`
    for (AlbumTintin _album in listAlbumTintin) {
      _album.albuminodeactive = 0;
      _album.albumpageactive = 1;
      _album.albumcaseactive = 0;
    }

/*    for (var i = 1; i < 23; i++) {
      print("album =" + listAlbumTintin[i].albumname + " i = " + i.toString());
      print("album pages =" + listAlbumTintin[i].albumpages.toString());    }*/


  }

  Future createPhotoBase(int _inode, String _casename) async {
    Uri url = Uri.parse(pathPHP + "createPHOTOBASE.php");
    setState(() {
      createPhotoBaseState = false;
    });

    var data = {
      "PHOTOINODE": _inode.toString(),
      "PHOTOUPLOADER": "PHL",
      "PHOTOCAT": "MM-TINTIN",
      "PHOTOFILETYPE": "jpg",
      "PHOTOFILESIZE": "0",
      "PHOTOFILENAME": _casename,
      "PHOTODATE": "",
      "PHOTOWIDTH": "0",
      "PHOTOHEIGHT": "0",
    };
    var res = await http.post(url, body: data);
    if (res.statusCode == 200) {
      setState(() {
        createPhotoBaseState = true;
      });
    }
  }

  int findRang(int _lapage) {

    // A ce Niveau listPhotoBaseWork est trié
    // Donc Page trouvé
    int lerang = 0;

    for (PhotoTintin _fotobase in listPhotoBaseWork) {
      if (_fotobase.photopage == _lapage) {

        setState(() {
          cestCeluiLa = lerang;
          listAlbumTintin[cetAlbum].albumpageactive =
              listPhotoBaseWork[cestCeluiLa].photopage;
        });
        updateCasePage();

        return (1);
      }
      lerang++;
    }
    return (0);

  }

  Expanded getget() {
    if (!getPhotoBaseState || !getTintinAlbumsState) {
      // AIE PML
      return Expanded(
        child: Column(
          children: const [
            (Text('.......')),
          ],
        ),
      );
    }

    return Expanded(
        child: (Column(
      children: [

        Container(
          alignment: Alignment.center,
          child:


            Image.network(
              "upload/" +
                  listPhotoBaseWork[cestCeluiLa].photofilename +
                  "." +
                  listPhotoBaseWork[cestCeluiLa].photofiletype,
            ),

        )
      ],
    )));
  }

  Future getTintinAlbums() async {
    Uri url = Uri.parse(pathPHP + "getALBUMSTINTIN.php");
    getTintinAlbumsState = false;
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;

      setState(() {
        listAlbumTintin =
            datamysql.map((xJson) => AlbumTintin.fromJson(xJson)).toList();
        getTintinAlbumsState = true;
        cleanTintinAlbums();
      });
    } else {}
  }

  Future getTintinBd() async {
    Uri url = Uri.parse(pathPHP + "readTINTINBD.php");
    getPhotoBaseState = false;
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      var datamysql = jsonDecode(response.body) as List;
      setState(() {
        listPhotoBase =
            datamysql.map((xJson) => PhotoTintin.fromJson(xJson)).toList();
        getPhotoBaseState = true;
        listPhotoBase
            .sort((a, b) => a.photofilename.compareTo(b.photofilename));
        cestCeluiLa = 0;

        cleanTintinAlbums(); // A faire  apres le tri des images
        selectAlbum("T1");
        cetAlbum=1;
      });
    } else {}
  }

  @override
  void initState() {
    super.initState();
    getTintinAlbums();
    getTintinBd();
    lockPhotoState = false;
    listPhotoBaseWork.clear();
  }

  nextAlbum() {
    setState(() {
      cetAlbum++;
      if (cetAlbum > 22) {
        cetAlbum = 1;

      }
    });
    selectAlbum("T" + cetAlbum.toString());

  updateCasePage();
  }

  nextCase() {
    setState(() {
      cestCeluiLa++;
      if (cestCeluiLa > listPhotoBaseWork.length) {
        cestCeluiLa--;
      }
      listAlbumTintin[cetAlbum].albumpageactive =
          listPhotoBaseWork[cestCeluiLa].photopage;
      listAlbumTintin[cetAlbum].albumcaseactive =
          listPhotoBaseWork[cestCeluiLa].photocase;
      listAlbumTintin[cetAlbum].albumpageactive =
          listPhotoBaseWork[cestCeluiLa].photopage;
      listAlbumTintin[cetAlbum].albuminodeactive =
          listPhotoBaseWork[cestCeluiLa].photoinode;
    });
    updateCasePage();
  }

  nextPage() {
    // Quelle est la page Active
    int _thisPage = listAlbumTintin[cetAlbum].albumpageactive;
    _thisPage = _thisPage + 1;
    if (_thisPage > listAlbumTintin[cetAlbum].albumpages) {
      _thisPage = 1;
    }
    listAlbumTintin[cetAlbum].albumpageactive = _thisPage;

    // Trouver le rang de cette page  image 0
    findRang(_thisPage);
    setState(() {
      cettePage = _thisPage; //??
      updateCasePage();
    });
  }
  lastPage() {
    // Quelle est la page Active

    int _thisPage = listAlbumTintin[cetAlbum].albumpages;

    listAlbumTintin[cetAlbum].albumpageactive = _thisPage;

    // Trouver le rang de cette page  image 0
    findRang(_thisPage);


    setState(() {
      cettePage = _thisPage; //??
      updateCasePage();
    });
  }
  prevAlbum() {
    setState(() {
      cetAlbum--;
      if (cetAlbum < 1) cetAlbum = 22;
      selectAlbum("T" + cetAlbum.toString());
    });

    selectAlbum("T" + cetAlbum.toString());

updateCasePage();
  }

  prevCase() {
    setState(() {
      cestCeluiLa--;
      if (cestCeluiLa < 0) cestCeluiLa = 0;
      listAlbumTintin[cetAlbum].albumpageactive =
          listPhotoBaseWork[cestCeluiLa].photopage;
      listAlbumTintin[cetAlbum].albumcaseactive =
          listPhotoBaseWork[cestCeluiLa].photocase;

      listAlbumTintin[cetAlbum].albuminodeactive =
          listPhotoBaseWork[cestCeluiLa].photoinode;

      updateCasePage();
    });
  }

  prevPage() {
    int _thisPage = listAlbumTintin[cetAlbum].albumpageactive;
    _thisPage = _thisPage - 1;
    if (_thisPage < 1) {
      _thisPage = 1;
    }
    listAlbumTintin[cetAlbum].albumpageactive = _thisPage;
    findRang(_thisPage);
    setState(() {
      cettePage = _thisPage; // ??

      updateCasePage();
    });
  }

  selectAlbum(String _thatCode) {
    //
    listPhotoBaseWork.clear();

    for (PhotoTintin _fotobase in listPhotoBase) {
      if (_fotobase.photocat == _thatCode) {
        listPhotoBaseWork.add(_fotobase);

      }
    }

    listPhotoBaseWork
        .sort((a, b) => a.photofilename.compareTo(b.photofilename));
    setState(() {

    cestCeluiLa=0;

    });

  }

  updateCasePage() {
    //cestCeluiLa cetteCase cetteCase sont des members
    setState(() {
      cetteCase = listPhotoBaseWork[cestCeluiLa].photocase;
      cettePage = listPhotoBaseWork[cestCeluiLa].photopage;
    });

  }




}
