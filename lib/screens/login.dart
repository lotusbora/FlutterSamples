import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttersamples/data/join_or_login.dart';
import 'package:fluttersamples/helper/login_background.dart';
import 'package:provider/provider.dart';
import 'forget_pw.dart';

class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CustomPaint(
              size: size,
              painter: LoginBackground(isJoin: Provider
                  .of<JoinOrLogin>(context)
                  .isJoin),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                _logoImage,
                Stack(children: <Widget>[
                  _inputForm(size),
                  _authButton(size),
                ]),
                Container(
                  height: size.height * 0.1,
                ),
                Consumer<JoinOrLogin>(
                  builder: (BuildContext context, JoinOrLogin joinOrLogin,
                      Widget child) =>
                      GestureDetector(
                          onTap: () {
                            joinOrLogin.toggle();
                          },
                          child: Text(joinOrLogin.isJoin
                              ? "Already Have an Account? Sign in"
                              : "Don't Have an Account? Create One",
                            style: TextStyle(
                                color: joinOrLogin.isJoin ? Colors.red : Colors
                                    .blue),)
                      ),
                ),
                Container(
                  height: size.height * 0.05,
                )
              ],
            )
          ],
        ));
  }

  void _register(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snackBar = SnackBar(content: Text('Please try again later.'));
      Scaffold.of(context).showSnackBar(snackBar);
    }

//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
  }

  void _login(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if (user == null) {
      final snackBar = SnackBar(content: Text('Please try again later.'));
      Scaffold.of(context).showSnackBar(snackBar);
    }

//    Navigator.push(context,
//        MaterialPageRoute(builder: (context) => MainPage(email: user.email)));
  }

  Widget get _logoImage =>
      Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/login.gif"),
            ),
          ),
        ),
      );

  Positioned _authButton(Size size) =>
      Positioned(
        left: size.width * 0.15,
        right: size.width * 0.15,
        bottom: 0,
        child: SizedBox(
          height: 50,
          child: Consumer<JoinOrLogin>(
            builder: (context, joinOrLogin, child) =>
                RaisedButton(
                    child: Text(
                        joinOrLogin.isJoin ? "Join" : "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white)
                    ),
                    color: joinOrLogin.isJoin ? Colors.red : Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        joinOrLogin.isJoin ? _register(context) : _login(
                            context);
                      }
                    }),
          ),
        ), //RaisedButton
      );

  Padding _inputForm(Size _size) {
    return  Padding(
        padding: EdgeInsets.all(_size.width * 0.05),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 6,
          child: Padding(
            padding:
            const EdgeInsets.only(left: 12, right: 16, top: 12, bottom: 32),
            child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.account_circle), labelText: "Email"),
                      validator: (String value) {
                        if (value.isEmpty)
                          return "Please input correct Email";

                        return null;
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordController,
                      decoration: InputDecoration(
                          icon: Icon(Icons.vpn_key), labelText: "Password"),
                      validator: (String value) {
                        if (value.isEmpty)
                          return "Please input correct password";

                        return null;
                      },
                    ),
                    Container(height: 8),
                    Consumer<JoinOrLogin>(
                      builder: (context, value, child) =>
                          Opacity(
                              opacity: value.isJoin ? 0 : 1,
                              child: GestureDetector(
                                  onTap: value.isJoin ? null : () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ForgetPw()));
                                  }
                                  , child: Text("Forget Password"))
                          ),
                    ),
                  ],
                )),
          ),
        ),
      );
  }

}
