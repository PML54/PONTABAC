import 'dart:core';

final listBD = [
  ConfigQuizzBd(
    "TINTIN",
    "ALBUMSTINTIN",
    "TINTINBD",
    22,
    2,
  ),
  ConfigQuizzBd(
    "TINTIN",
    "ALBUMSTINTIN",
    "TINTINBD",
    23,
    2,
  ),
  ConfigQuizzBd(
    "ASTERIX",
    "ALBUMSASTERIX",
    "ASTERIXBD",
    13,
    1,
  ),
  ConfigQuizzBd(
    "SARDOU",
    "ALBUMSASTERIX",
    "SARDOUBD",
    26,
    1,
  ),
  ConfigQuizzBd(
    "BREL",
    "ALBUMSASTERIX",
    "BRELBD",
    13,
    1,
  ),
];

class AlbumBd {
  int albumid = 0;
  String albumname = "xx";
  int albumpub = 0;
  String albumtome = "xx";
  String albumsigle = "xx";
  int albumpages = 0;
  int albumpageactive = 0;
  int albumcaseactive = 0;
  int albuminodeactive = 0;
  String covername = "xxx";

  AlbumBd({
    required this.albumid,
    required this.albumname,
    required this.albumpub,
    required this.albumtome,
    required this.albumsigle,
    required this.albumpages,
    required this.albumpageactive,
    required this.albumcaseactive,
    required this.albuminodeactive,
    required this.covername,
  });

  factory AlbumBd.fromJson(Map<String, dynamic> json) {
    return AlbumBd(
      albumid: int.parse(json['ALBUMID']),
      albumname: json['ALBUMNAME'] as String,
      albumpub: int.parse(json['ALBUMPUB']),
      albumtome: json['ALBUMTOME'] as String,
      albumsigle: json['ALBUMSIGLE'] as String,
      albumpages: int.parse(json['ALBUMPAGES']),
      albumpageactive: int.parse(json['ALBUMPAGEACTIVE']),
      albumcaseactive: int.parse(json['ALBUMCASEACTIVE']),
      albuminodeactive: int.parse(json['ALBUMINODEACTIVE']),
      covername: json['COVERNAME'] as String,
    );
  }
}
//
//$bdname="QUIZZSONGLIMITED";
//SONGNAME | varchar(50)  | NO   |     | NULL    |                |
//| SONGID   | int unsigned | NO   | PRI | NULL    | auto_increment |
//

class QuizzSongs {
  int songid = 1;
  String songname = "xx";

  QuizzSongs({
    required this.songid,
    required this.songname,
  });

  factory QuizzSongs.fromJson(Map<String, dynamic> json) {
    return QuizzSongs(
      songid: int.parse(json['SONGID']),
      songname: json['SONGNAME'] as String,
    );
  }
}

class AlbumMz {
  int albumid = 1;
  String albumcode = "xx";
  int albumordre = 1;
  int albumyear = 0;
  int albumsongs = 0;
  String albumname = "xxx";

  AlbumMz({
    required this.albumid,
    required this.albumcode,
    required this.albumordre,
    required this.albumyear,
    required this.albumname,
    required this.albumsongs,
  });

  factory AlbumMz.fromJson(Map<String, dynamic> json) {
    return AlbumMz(
      albumid: int.parse(json['ALBUMID']),
      albumcode: json['ALBUMCODE'] as String,
      albumordre: int.parse(json['ALBUMORDRE']),
      albumyear: int.parse(json['ALBUMYEAR']),
      albumname: json['ALBUMNAME'] as String,
      albumsongs: int.parse(json['ALBUMSONGS']),
    );
  }
}

//
// ALBUMID    | int         | NO   | PRI | NULL    | auto_increment |
// ALBUMCODE  | varchar(5)  | YES  |     | NULL    |                |
// ALBUMORDRE | int         | YES  |     | NULL    |                |
//ALBUMYEAR  | int         | NO   |     | NULL    |                |
// ALBUMNAME  | varchar(35) | NO   |     | NULL    |                |
//
class AlbumTintin {
  int albumid = 0;
  String albumname = "xx";
  int albumpub = 0;
  String albumtome = "xx";
  String albumsigle = "xx";
  int albumpages = 0;
  int albumpageactive = 0;
  int albumcaseactive = 0;
  int albuminodeactive = 0;
  String covername = "xxx";

  AlbumTintin({
    required this.albumid,
    required this.albumname,
    required this.albumpub,
    required this.albumtome,
    required this.albumsigle,
    required this.albumpages,
    required this.albumpageactive,
    required this.albumcaseactive,
    required this.albuminodeactive,
    required this.covername,
  });

  factory AlbumTintin.fromJson(Map<String, dynamic> json) {
    return AlbumTintin(
      albumid: int.parse(json['ALBUMID']),
      albumname: json['ALBUMNAME'] as String,
      albumpub: int.parse(json['ALBUMPUB']),
      albumtome: json['ALBUMTOME'] as String,
      albumsigle: json['ALBUMSIGLE'] as String,
      albumpages: int.parse(json['ALBUMPAGES']),
      albumpageactive: int.parse(json['ALBUMPAGEACTIVE']),
      albumcaseactive: int.parse(json['ALBUMCASEACTIVE']),
      albuminodeactive: int.parse(json['ALBUMINODEACTIVE']),
      covername: json['COVERNAME'] as String,
    );
  }
}

class ConfigQuizzBd {
  String bdThis = "";
  String bdName = "";
  String bdStory = "";
  int bdLast = 0;
  int bdFirst = 0;

  ConfigQuizzBd(
    this.bdThis,
    this.bdName,
    this.bdStory,
    this.bdLast,
    this.bdFirst,
  );
}

class GameHistoric {
  int thatinode = 0; // Question
  int bdreponse; // reponse
  int goodbd;
  List<int> bdquizz = []; // Proposals

  GameHistoric(this.thatinode, this.goodbd, this.bdreponse, this.bdquizz);
}

class GamePhotoSelect {
  int gamecode = 0;
  int photoid = 0;

  GamePhotoSelect({
    required this.gamecode,
    required this.photoid,
  });

  factory GamePhotoSelect.fromJson(Map<String, dynamic> json) {
    return GamePhotoSelect(
      gamecode: int.parse(json['GAMECODE']),
      photoid: int.parse(json['PHOTOID']),
    );
  }
}

class GameQuizz {
  int gameid = 0; // Auto
  String gamedate = "2022-05-05";
  String gamer = "XWX";
  int gamerid = 0;
  int gameforce = 0;
  int gamescore = 0;

  GameQuizz(
      {required this.gameid,
      required this.gamedate,
      required this.gamer,
      required this.gamerid,
      required this.gameforce,
      required this.gamescore});

  factory GameQuizz.fromJson(Map<String, dynamic> json) {
    return GameQuizz(
      gameid: int.parse(json['GAMEID']),
      gamedate: json['GAMEDATE'] as String,
      gamer: json['GAMER'] as String,
      gamerid: int.parse(json['GAMERID']),
      gameforce: int.parse(json['GAMEFORCE']),
      gamescore: int.parse(json['GAMESCORE']),
    );
  }
} // Games*/

//
class GameQuizzScores {
  //SELECT GAMER, GAMEID,GAMEFORCE,GAMENBGOOD,GAMENBQUEST,GAMEMAX,GAMESCORE

  String gamer = "XWX";
  int gameid = 0; // Auto
  int gameforce = 0;
  int gamenbgood = 0;
  int gamenbquest = 0;
  int gamemax = 0;
  int gamescore = 0;
  int gamenote = 0;
  String thatbd = "TINTIN";

  GameQuizzScores(
      {required this.gamer,
      required this.gameid,
      required this.gameforce,
      required this.gamenbgood,
      required this.gamenbquest,
      required this.gamemax,
      required this.gamescore,
      required this.gamenote,
      required this.thatbd});

  factory GameQuizzScores.fromJson(Map<String, dynamic> json) {
    return GameQuizzScores(
      gamer: json['GAMER'] as String,
      gameid: int.parse(json['GAMEID']),
      gameforce: int.parse(json['GAMEFORCE']),
      gamenbgood: int.parse(json['GAMENBGOOD']),
      gamenbquest: int.parse(json['GAMENBQUEST']),
      gamemax: int.parse(json['GAMEMAX']),
      gamescore: int.parse(json['GAMESCORE']),
      gamenote: int.parse(json['GAMENOTE']),
      thatbd: json['THATBD'] as String,
    );
  }
} // Games*/

//select  GAMER, GAMEID,GAMEFORCE,GAMENBGOOD,GAMENBQUEST,GAMEMAX,GAMESCORE FROM  GAMEQUIZZBD;

class MemopolUsers {
  int uid = 0;
  int ustatus = 0;
  int uprofile = 0;
  String uname = "UNAMEX";
  String upseudo = "AAAAX";
  String umail = "AAA@WW.ZZZ";
  String uipcreate = "FF.FF.FF.FF.FF";
  String uiptoday = "FF.FF.FF.FF.FF";
  String ucdate = "06-06-2022";
  String uldate = "06-06-2022";
  String messadmin = "";

  // 64  Admin 32  Game Manager  16 Game User  4 Invited 2 nothing bit 1 : O  =0
  MemopolUsers(
      {required this.uid,
      required this.ustatus,
      required this.uprofile,
      required this.uname,
      // required this.upass,
      required this.upseudo,
      required this.umail,
      required this.uipcreate,
      required this.uiptoday,
      required this.ucdate,
      required this.uldate,
      required this.messadmin});

  factory MemopolUsers.fromJson(Map<String, dynamic> json) {
    return MemopolUsers(
      uid: int.parse(json['UID']),
      ustatus: int.parse(json['USTATUS']),
      uprofile: int.parse(json['UPROFILE']),
      uname: json['UNAME'] as String,
      //    upass: json['UPASS'] as String,
      upseudo: json['UPSEUDO'] as String,
      umail: json['UMAIL'] as String,
      uipcreate: json['UIPCREATE'] as String,
      uiptoday: json['UIPTODAY'] as String,
      ucdate: json['UCDATE'] as String,
      uldate: json['ULDATE'] as String,
      messadmin: json['MESSADMIN'] as String,
    );
  }
}

class PhotoBd {
  int photofilesize = 0;
  int photoheight = 0;
  int photoid = 0;
  int photoinode = 0;
  int photowidth = 0;
  String photocat = "NOT";
  String photouploader = "YYY";
  String photodate = "05-05-2022";
  String photofilename = "FFFF";
  String photofiletype = "TTT";
  int photophl = 0;
  int photoalbum = 0;
  int photopage = 0;
  int photocase = 0;

  PhotoBd({
    required this.photofilesize,
    required this.photoheight,
    required this.photoid,
    required this.photoinode,
    required this.photowidth,
    required this.photocat,
    required this.photouploader,
    required this.photodate,
    required this.photofilename,
    required this.photofiletype,
    required this.photophl,
    required this.photoalbum,
    required this.photopage,
    required this.photocase,
  });

  factory PhotoBd.fromJson(Map<String, dynamic> json) {
    return PhotoBd(
      photofilesize: int.parse(json['PHOTOFILESIZE']),
      photoheight: int.parse(json['PHOTOHEIGHT']),
      photoid: int.parse(json['PHOTOID']),
      photoinode: int.parse(json['PHOTOINODE']),
      photowidth: int.parse(json['PHOTOWIDTH']),
      photocat: json['PHOTOCAT'] as String,
      photouploader: json['PHOTOUPLOADER'] as String,
      photodate: json['PHOTODATE'] as String,
      photofilename: json['PHOTOFILENAME'] as String,
      photofiletype: json['PHOTOFILETYPE'] as String,
      photophl: int.parse(json['PHOTOPHL']),
      photoalbum: int.parse(json['PHOTOALBUM']),
      photopage: int.parse(json['PHOTOPAGE']),
      photocase: int.parse(json['PHOTOCASE']),
    );
  }
}

class PhotoCat {
  String photocat = "XXXX";
  String photocast = "XXXX";
  int nbphotos = 0;
  int selected = 0;
  int firstphotoid = 0;

  PhotoCat({
    required this.photocat,
  });

  factory PhotoCat.fromJson(Map<String, dynamic> json) {
    return PhotoCat(
      photocat: json['PHOTOCAT'] as String,
    );
  }

  setNumber(int _number) {
    nbphotos = _number;
  }

  setphotoid(_thatphotoid) {
    firstphotoid = _thatphotoid;
  }

  setSelected(int _selected) {
    selected = _selected;
  }

  supMM() {
    photocast = photocat.substring(3);
  }
}

class PhotoTintin {
  int photofilesize = 0;
  int photoheight = 0;
  int photoid = 0;
  int photoinode = 0;
  int photowidth = 0;
  String photocat = "NOT";
  String photouploader = "YYY";
  String photodate = "05-05-2022";
  String photofilename = "FFFF";
  String photofiletype = "TTT";
  int photophl = 0;
  int photoalbum = 0;
  int photopage = 0;
  int photocase = 0;

  PhotoTintin({
    required this.photofilesize,
    required this.photoheight,
    required this.photoid,
    required this.photoinode,
    required this.photowidth,
    required this.photocat,
    required this.photouploader,
    required this.photodate,
    required this.photofilename,
    required this.photofiletype,
    required this.photophl,
    required this.photoalbum,
    required this.photopage,
    required this.photocase,
  });

  factory PhotoTintin.fromJson(Map<String, dynamic> json) {
    return PhotoTintin(
      photofilesize: int.parse(json['PHOTOFILESIZE']),
      photoheight: int.parse(json['PHOTOHEIGHT']),
      photoid: int.parse(json['PHOTOID']),
      photoinode: int.parse(json['PHOTOINODE']),
      photowidth: int.parse(json['PHOTOWIDTH']),
      photocat: json['PHOTOCAT'] as String,
      photouploader: json['PHOTOUPLOADER'] as String,
      photodate: json['PHOTODATE'] as String,
      photofilename: json['PHOTOFILENAME'] as String,
      photofiletype: json['PHOTOFILETYPE'] as String,
      photophl: int.parse(json['PHOTOPHL']),
      photoalbum: int.parse(json['PHOTOALBUM']),
      photopage: int.parse(json['PHOTOPAGE']),
      photocase: int.parse(json['PHOTOCASE']),
    );
  }
}

class PhotoBase {
  int photofilesize = 0;
  int photoheight = 0;
  int photoid = 0;
  int photoinode = 0;
  int photowidth = 0;
  String photocat = "NOT";
  String photouploader = "YYY";
  String photodate = "05-05-2022";
  String photofilename = "FFFF";
  String photofiletype = "TTT";
  String memetempo = ""; // <TODO> Le ptit plu
  // Add
  bool isSelected = false;
  double extraWidth = 100;
  double extraHeight = 100;

  PhotoBase({
    required this.photofilesize,
    required this.photoheight,
    required this.photoid,
    required this.photoinode,
    required this.photowidth,
    required this.photocat,
    required this.photouploader,
    required this.photodate,
    required this.photofilename,
    required this.photofiletype,
  });

  factory PhotoBase.fromJson(Map<String, dynamic> json) {
    return PhotoBase(
      photofilesize: int.parse(json['PHOTOFILESIZE']),
      photoheight: int.parse(json['PHOTOHEIGHT']),
      photoid: int.parse(json['PHOTOID']),
      photoinode: int.parse(json['PHOTOINODE']),
      photowidth: int.parse(json['PHOTOWIDTH']),
      photocat: json['PHOTOCAT'] as String,
      photouploader: json['PHOTOUPLOADER'] as String,
      photodate: json['PHOTODATE'] as String,
      photofilename: json['PHOTOFILENAME'] as String,
      photofiletype: json['PHOTOFILETYPE'] as String,
    );
  }
}
