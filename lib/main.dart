import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pontabac/admintintin.dart';
import 'package:pontabac/configquizz.dart';
import 'package:pontabac/quizzbd.dart';
import 'package:pontabac/quizzclass.dart';
import 'package:pontabac/quizzcommons.dart';
import 'package:pontabac/quizzique.dart';
import 'package:pontabac/userconnect.dart';
import 'package:pontabac/usercreate.dart';
import 'package:pontabac/videosardou.dart';
import 'package:pontabac/vinyl.dart';
import 'package:pontabac/platine.dart';
void main() {
  runApp(const MaterialApp(title: 'Navigation Basics', home: MenoPaul()));
}

class MenoPaul extends StatefulWidget {
  const MenoPaul({Key? key}) : super(key: key);

  @override
  State<MenoPaul> createState() => _MenoPaulState();
}

class _MenoPaulState extends State<MenoPaul> {
  String errorMessage = "";
  bool boolMsg = false;
  bool isAdmin = false;
  bool isGamer = false;
  String connectedGuy = "";
  List<MemopolUsers> listMemopolUsers = [];

  @override
  Widget build(BuildContext context) {
    setState(() {});
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent
            //color set to transperent or set your own color
            ));
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bac 2.11 Candidat ' + QuizzCommons.myPseudo,
          style: GoogleFonts.averageSans(fontSize: 15.0),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: 400,
          constraints:
              BoxConstraints(minHeight: MediaQuery.of(context).size.height
                  //set minimum height equal to 100% of VH
                  ),
          width: MediaQuery.of(context).size.width,
          //make width of outer wrapper to 100%
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.orange,
                Colors.deepOrangeAccent,
                Colors.red,
                Colors.redAccent,
              ],
            ),
          ),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //---> 'Espace Candidat',
                  Visibility(
                    visible: QuizzCommons.myUid == 0,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        child: Text(
                          'Espace Candidat',
                          style: GoogleFonts.averageSans(
                              fontSize: 25.0, color: Colors.black),
                        ),
                        onPressed: () async {
                          listMemopolUsers = await (Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          ));
                          setState(() {
                            connectedGuy = listMemopolUsers[0].uname;
                            if (listMemopolUsers[0].uprofile & ADMIN_PML ==
                                ADMIN_PML) {
                              isAdmin = true;
                            }
                            if (listMemopolUsers[0].uprofile & 1 == 1) {
                              isGamer = true;
                            }
                          });
                        },
                      ),
                    ),
                  ),
                  //--->   'Nouveau Candidat?',
                  // VideoPlayerApp

                  // --> Reviser       Tinrtin
                  Visibility(
                    visible: QuizzCommons.myProfile == CERTIFIED_PML,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        child: Text(
                          'Réviser TINTIN',
                          style: GoogleFonts.averageSans(fontSize: 15.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminTintin()),
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: QuizzCommons.myProfile == CERTIFIED_PML,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        child: Text(
                          'Test Video',
                          style: GoogleFonts.averageSans(fontSize: 15.0),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const VideoPlayerApp()),
                          );
                        },
                      ),
                    ),
                  ),
                  //--> Tintin
                  Visibility(
                    visible: QuizzCommons.myProfile & 1 == 1,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        child: Text(
                          'Bac T(intin)',
                          style: GoogleFonts.averageSans(fontSize: 25.0),
                        ),
                        onPressed: () {
                          QuizzCommons.thatBac = TINTIN; // Tintin
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuizzBd()),
                          );
                        },
                      ),
                    ),
                  ),

                  Visibility(
                    visible: QuizzCommons.myProfile == CERTIFIED_PML,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        child: Text(
                          'Bac A(sterix)',
                          style: GoogleFonts.averageSans(fontSize: 25.0),
                        ),
                        onPressed: () {
                          QuizzCommons.thatBac = ASTERIX; //
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuizzBd()),
                          );
                        },
                      ),
                    ),
                  ),
                  //--> Sardou
                  Visibility(
                    visible: QuizzCommons.myProfile & 1 == 1,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        child: Text(
                          'Bac S(ardou) A(lbums)',
                          style: GoogleFonts.averageSans(fontSize: 22.0),
                        ),
                        onPressed: () {
                          QuizzCommons.thatBac = SARDOU;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const QuizzZizik()),
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: QuizzCommons.myProfile & 1 == 1,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        child: Text(
                          'Bac S(ardou) T(itres)',
                          style: GoogleFonts.averageSans(fontSize: 22.0),
                        ),
                        onPressed: () {
                          QuizzCommons.thatBac = SARDOUT;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Vinyl()),
                          );
                        },
                      ),
                    ),
                  ),
                  Visibility(
                    visible: QuizzCommons.myProfile & 1 == 1,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ElevatedButton(
                        child: Text(
                          'Bac B(rel)',
                          style: GoogleFonts.averageSans(fontSize: 22.0),
                        ),
                        onPressed: () {
                          QuizzCommons.thatBac = BREL;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Platine()),
                          );
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: QuizzCommons.myProfile != CERTIFIED_PML &&
                          QuizzCommons.myProfile != 5,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          child: Text(
                            'Nouveau Candidat?',
                            style: GoogleFonts.averageSans(
                                fontSize: 15.0, color: Colors.white),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreatePage()),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      isAdmin = false;
      isGamer = false;
    });
  }
}
