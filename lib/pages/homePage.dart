import 'package:flutter/material.dart';
import 'package:memori/data/data.dart';
import 'package:memori/model/tile_model.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    pairs = getPairs();

    pairs.shuffle();

    visiblePairs = pairs;
    selcted = true;
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        print("2 seconds done");

        visiblePairs = getQuestions();
        selcted = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    Orientation currentOrientation = MediaQuery.of(context).orientation;
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Column(
          children: <Widget>[
            Text(
              "$points/800",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
            ),
            Text("pontos"),
            SizedBox(
              height: currentOrientation == Orientation.portrait ? hei * 0.1 : hei * 0.05,
            ),
            points != 800
                ? GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        mainAxisSpacing: 0.0, maxCrossAxisExtent: 100),
                    children: List.generate(visiblePairs.length, (index) {
                      return Tile(
                        imageAssetsPat: visiblePairs[index].getImageAssetPath(),
                        parent: this,
                        tileIndex: index,
                      );
                    }),
                  )
                : Container(
                    width: wid,
                    height: hei * 0.4,
                    child: Center(
                        child: FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      padding: EdgeInsets.all(8.0),
                      splashColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.blue)),
                      onPressed: () {
                        setState(() {
                          points = 0;

                          pairs = getPairs();

                          pairs.shuffle();

                          visiblePairs = pairs;
                          selcted = true;
                          Future.delayed(const Duration(seconds: 5), () {
                            print("2 seconds done");
                            setState(() {
                              visiblePairs = getQuestions();
                              selcted = false;
                            });
                          });
                        });
                      },
                      child: Text(
                        "recomeçar",
                        style: TextStyle(fontSize: 20.0),
                      ),
                    )),
                  )
          ],
        ),
      ),
    ));
  }
}

class Tile extends StatefulWidget {
  String imageAssetsPat;
  int tileIndex;

  _HomePageState parent;
  Tile({this.imageAssetsPat, this.parent, this.tileIndex});

  @override
  _TileState createState() => _TileState();
}

class _TileState extends State<Tile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!selcted) {
          if (selectedImageAssetPath != "") {
            if (selectedImageAssetPath ==
                pairs[widget.tileIndex].getImageAssetPath()) {
              print("foi");
              selcted = true;
              Future.delayed(const Duration(seconds: 2), () {
                points += 100;

                setState(() {});
                widget.parent.setState(() {
                  pairs[widget.tileIndex].setImageAssetPath("");
                  pairs[selectedTileIndex].setImageAssetPath("");
                  selectedImageAssetPath = "";
                  selcted = false;
                });
              });
            } else {
              print("nao foi");
              selcted = true;
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {});
                widget.parent.setState(() {
                  pairs[widget.tileIndex].setIsSelected(false);
                  pairs[selectedTileIndex].setIsSelected(false);
                  selectedImageAssetPath = "";
                  selcted = false;
                });
              });
            }
          } else {
            selectedTileIndex = widget.tileIndex;
            selectedImageAssetPath =
                pairs[widget.tileIndex].getImageAssetPath();
          }
          print("click");
          setState(() {
            pairs[widget.tileIndex].setIsSelected(true);
          });
        } else {}
      },
      child: Container(
        margin: EdgeInsets.all(7),
        child: pairs[widget.tileIndex].getImageAssetPath() == ""
            ? Image.asset("assets/correct.png")
            : Image.asset(pairs[widget.tileIndex].getIsSelected()
                ? pairs[widget.tileIndex].getImageAssetPath()
                : widget.imageAssetsPat),
      ),
    );
  }
}
