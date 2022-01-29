import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/http_exp.dart';
import 'package:rest_prov/providers/auth.dart';

class AuthSC extends StatelessWidget {
  const AuthSC({Key key}) : super(key: key);
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    final dS = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red.withOpacity(0.4),
                  Colors.yellow.withOpacity(0.8),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              height: dS.height,
              width: dS.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 90),
                      transform: Matrix4.rotationZ(-11 * pi / 180)
                        ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.red,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black38,
                            offset: Offset(0, 2.0),
                          ),
                        ],
                      ),
                      child: const Text(
                        "MARAH SHOP",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Anton',
                            fontSize: 40,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: dS.width > 600 ? 2 : 1,
                    child: AuthCard(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key key}) : super(key: key);

  @override
  _AuthCardState createState() => _AuthCardState();
}

enum AuthMode { Login, SignUp }

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, String> _authdata = {
    'email': '',
    'password': '',
  };
  AuthMode _authMode = AuthMode.Login;

  bool _isloading = false;

  final _passCon = TextEditingController();
  final _emailCon = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _oppacityAnimation;
  //late var val;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 400),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -0.15),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _oppacityAnimation = Tween<double>(
      begin: 0,
      end: 1.0,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    FocusScope.of(context).unfocus();
    _formKey.currentState?.save();
    setState(() {
      _isloading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        await Provider.of<Auth>(context, listen: false)
            .logIn(_authdata['email'], _authdata['password']);
      } else {
        await Provider.of<Auth>(context, listen: false)
            .signUp(_authdata['email'], _authdata['password'])
            .whenComplete(() {
          if (_isloading == false) {
            setState(() {
              _authMode = AuthMode.Login;
            });
          }
        });
      }
    } on HttpExp catch (e) {
      var emsg = 'Authentication failed';
      if (e.toString().contains('EMAIL_EXISTS')) {
        emsg = "This email address is already exist!";
      } else if (e.toString().contains('INVALID_EMAIL')) {
        emsg = "This is not a valid email!";
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        emsg = "This password is too weak!";
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        emsg = "Could not find a user with that email!";
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        emsg = "Invalid password!";
      }
      _showE(emsg);
    } catch (e) {
      const emsg = 'Could not authenticate you . Please try again later!';
      _showE(emsg);
    }

    setState(() {
      _isloading = false;
    });
  }

  String testmod = 'Log in';
  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.SignUp;
        testmod = 'Sing Up';
      });
      _controller.forward();
    } else if (_authMode == AuthMode.SignUp) {
      setState(() {
        _authMode = AuthMode.Login;
        testmod = 'Log in';
      });
      _controller.reverse();
    }
  }

  void _showE(String emsg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erorr Founded'),
        titleTextStyle: TextStyle(color: Colors.teal),
        content: Text(emsg),
        elevation: 15,
        actions: [
          ElevatedButton(
            style: ButtonStyle(elevation:  MaterialStateProperty.all(8) ,
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)
                    ))
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'OK',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),
            ),
          )
        ],
        actionsAlignment: MainAxisAlignment.center,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        alignment: Alignment.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dS = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 8,
      child: AnimatedContainer(
        duration: Duration(microseconds: 300),
        curve: Curves.easeIn,
        height: _authMode == AuthMode.SignUp ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.SignUp ? 320 : 260),
        width: dS.width * 0.75,
        padding: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _emailCon,
                  validator: (val) {
                    if (val.isEmpty || !val.contains('@')) {
                      return "Invalid E-mail";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authdata['email'] = val;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  controller: _passCon,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (val) {
                    if (val.isEmpty || val.length < 6) {
                      return "Invalid password";
                    }
                    return null;
                  },
                  onSaved: (val) {
                    _authdata['password'] = val;
                  },
                ),
                AnimatedContainer(
                  duration: Duration(microseconds: 300),
                  curve: Curves.easeIn,
                  constraints: BoxConstraints(
                    minHeight: _authMode == AuthMode.SignUp ? 60 : 0,
                    maxHeight: _authMode == AuthMode.SignUp ? 120 : 0,
                  ),
                  child: FadeTransition(
                    opacity: _oppacityAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: TextFormField(
                        enabled: _authMode == AuthMode.SignUp ? true : false,
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        keyboardType: TextInputType.visiblePassword,
                        validator: (val1) {
                          if (_authMode == AuthMode.SignUp &&
                              val1 != _passCon.text) {
                            return 'password did not match!';
                          }
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8),
                if (_isloading) CircularProgressIndicator(),
                ElevatedButton(
                  child: Text('$testmod'),
                  onPressed: _submit,
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                      ),
                      //textStyle: MaterialStateProperty.all<TextStyle>(),
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red)),
                ),
                TextButton(
                  onPressed: _switchAuthMode,
                  child: Text(
                      '${testmod == 'Log in' ? 'Signup' : 'Login '}  Insted '),
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
