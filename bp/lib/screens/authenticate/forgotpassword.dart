
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  String email;
  String error = '';
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.white,
            Colors.white,
            Colors.white70,
          ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                SizedBox(height: 10.0),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Reset' '\nPassword',
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                    )),
                SizedBox(height: 80.0),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)))),
                  validator: (val) => val.isEmpty ? 'Enter your email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                ),
                SizedBox(height: 20.0),
                RaisedButton(
                    textColor: Colors.white,
                    color: Colors.transparent,
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(20.0),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: LinearGradient(
                          colors: <Color>[
                             Color.fromARGB(255, 30, 55, 91),
                            Colors.black,
                          ],
                        ),
                      ),
                      padding: const EdgeInsets.fromLTRB(40, 15, 40, 15),
                      child: const Text(
                        'Send',
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = FirebaseAuth.instance
                            .sendPasswordResetEmail(email: email);
                        scaffoldKey.currentState.showSnackBar(new SnackBar(
                            content: new Text("Please check your email")));
                        if (result == null) {
                          setState(() {
                            loading = false;
                            error = 'Invalid input';
                          });
                        }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
