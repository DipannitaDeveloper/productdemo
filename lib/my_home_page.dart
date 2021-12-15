import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:productlist/add_edit_product.dart';
import 'package:url_launcher/url_launcher.dart';

import 'DBHelper.dart';
import 'product.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{
  int _counter = 0;
  final _formkey2 = GlobalKey<FormState>();
  bool isUpdating;


  var dbHelper;
  String search;
  AnimationController _controller;
  Animation<Offset> _offsetAnimation;

  Future<List<Product>> employees;

  TextEditingController searchcon = TextEditingController();
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     isUpdating = false;
    dbHelper = DBHelper();

    controller = new AnimationController(
        duration: Duration(seconds: 3), vsync: this)..addListener(() =>
        setState(() {}));
    animation = Tween(begin: 500.0, end: 0.0).animate(controller);

    refreshlist();

  }

  refreshlist() {
    setState(() {
      employees = dbHelper.getProducts();
      controller.forward();
    });
  }

  searchrefreshlist(String namesearched) {
    setState(() {
      employees = dbHelper.getProductsSearch(namesearched, "999");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: Colors.white38,
      appBar: AppBar(
        title: Center(child: Text("PRODUCT LIST")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
             _addbtn(),_searchform(), _list()
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }


  _searchform() =>
      Container(
        alignment: Alignment.topCenter,
        color: Colors.yellow,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formkey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(

                controller: searchcon,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Search'),
                validator: (val) => val.length == 0 ? 'Enter name' : null,
                onSaved: (val) => search = val,
              ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                  [
                    FlatButton(
                      color: Colors.purpleAccent,
                      onPressed: searching,
                      child: const Text('SEARCH'),),
                    FlatButton(
                      color: Colors.purpleAccent,
                      onPressed: refreshlist,
                      child: const Text('CANCEL'),),

                  ],)




            ],
          ),
        ),
      );

  datatatble(List<Product> employees) {
    return ListView.builder(
      scrollDirection: Axis.vertical,

      itemCount: employees.length,


      itemBuilder: (BuildContext context,int index) {

        return Transform.translate(
          offset: Offset(animation.value, 0.0),
          child: Container(
            margin: const EdgeInsets.all(15.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.purpleAccent),
                borderRadius: BorderRadius.all( Radius.circular(5.0))
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      children: [
                        Text("Name: "+employees[index].name),
                        Text("Launch At: " +employees[index].launchedAt),
                        Linkify(
                            onOpen: (link) async {
                              if (await canLaunch(link.url)) {
                                await launch(link.url);
                              } else {
                                throw 'Could not launch $link';
                              }
                            },text: "Launch Site: " +employees[index].launchSite),
                        Text("Popularity: " +employees[index].popularity)
                      ]),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      dbHelper.delete(employees[index].id);
                      refreshlist();
                    },
                  )
                ]
            ),
          ),
        );
        // )
      },
    );


    // itemCount: employees.length,
    // itemBuilder: (BuildContext ctxt, int index) {
    //   return Column(
    //       children: [
    //         Text(employees[index].name),
    //         Text(employees[index].launchedAt),
    //         IconButton(
    //           icon: Icon(Icons.delete),
    //           onPressed: () {
    //             dbHelper.delete(employees[index].id);
    //             refreshlist();
    //           },
    //         )
    //       ]);
    // }

    //);
  }

  _list() =>
      Expanded(

        child: FutureBuilder(
          future: employees,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return datatatble(snapshot.data);
            }
            if (null == snapshot.data || snapshot.data.length == 0) {
              return Text("No Record Found");
            }

            return CircularProgressIndicator();
          },
        ),
      );






  searching() {
    if (_formkey2.currentState.validate()) {
      searchrefreshlist(searchcon.text);
      // refreshlist();
    }
    else {

    }
  }

  _addbtn() {
    return GestureDetector(
      onTap: () => {
      Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditProduct()))
      },
      child: Container(
        width: MediaQuery.of(context).size.width/1.2,
        height: 35,
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        child:Center(
          child: Text("ADD", style: TextStyle(
            color: Colors.white, fontSize: 16
          ),),
        )
      ),
    );
  }
}
