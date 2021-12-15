import 'package:flutter/material.dart';
import 'package:productlist/DBHelper.dart';
import 'package:productlist/my_home_page.dart';
import 'package:productlist/product.dart';


class AddEditProduct extends StatefulWidget {
  const AddEditProduct({Key key}) : super(key: key);

  @override
  _AddEditProductState createState() => _AddEditProductState();
}

class _AddEditProductState extends State<AddEditProduct> {
  String name;
  String launchedat;
  String popularity;
  String launchSite;
  int userid;
  bool isUpdating;

  TextEditingController namecon = TextEditingController();
  TextEditingController launchat = TextEditingController();
  TextEditingController popular = TextEditingController();
  TextEditingController site = TextEditingController();

  var dbHelper = DBHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DBHelper();
    isUpdating = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   backgroundColor: Colors.white38,
      appBar: AppBar(
        title: Center(child: Text("ADD PRODUCT")),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            _form()
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  final _formkey = GlobalKey<FormState>();
  _form() =>
      Container(
        alignment: Alignment.topCenter,
        color: Colors.white,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        child: Form(
          key: _formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(

                controller: namecon,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (val) => val.length == 0 ? 'Enter name' : null,
                onSaved: (val) => name = val,
              ),
              TextFormField(
                controller: launchat,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(labelText: 'Lanch at'),
                validator: (val) => val.length == 0 ? 'Enter Launch date' : null,
                onSaved: (val) => launchedat = val,
              ),
              TextFormField(
                controller: site,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: 'Launch Site'),
                validator: (val) => val.length == 0 ? 'Enter Site' : null,
                onSaved: (val) =>  launchSite = val,
              ),
              TextFormField(
                controller: popular,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: InputDecoration(labelText: 'rate populatiry out of 5'),
                validator: (val) => val.length == 0 ? 'rate populatiry out of 5' : null,
                onSaved: (val) =>  popularity = val,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(onPressed: velidate,
                    color: Colors.purpleAccent,
                    child: Text(isUpdating ? 'UPDATE' : 'ADD'),),
                  FlatButton(onPressed: () {

                    setState(() {
                      isUpdating = false;
                    });
                    clearName();
                  }
                      , child: Text('CANCEL'))
                ],
              )
            ],
          ),
        ),
      );

  velidate() {
    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      print(launchSite);
      print(userid);
      print(launchedat);
      if (isUpdating) {
        Product e = Product(userid, name, launchedat.toString(), launchSite, popularity);
        dbHelper.update(e);
        setState(() {
          isUpdating = false;
        });
      }
      else {
        Product e = Product(null, name, launchedat.toString(), launchSite, popularity);
        dbHelper.save(e);
      }
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
          MyHomePage()), (Route<dynamic> route) => false);

    }

  }
  clearName() {
    namecon.text = "";
    launchat.text = "";
    popular.text = "";
    site.text = "";
  }
}
