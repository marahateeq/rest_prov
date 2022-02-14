import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rest_prov/const/colors.dart';
import 'package:rest_prov/providers/auth.dart';
import 'package:rest_prov/utils/helper.dart';

import '../providers/restuarants.dart';
import 'homepage.dart';

class Profile extends StatefulWidget {
  static const routeName = "/profile";

  //final rest =await Provider.of<Restaurants>(context).fetchRestaurant();

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map m, _m;
  String emaild = "null";
  Future<void> getData() async {
    await Provider.of<Auth>(context, listen: false).userData().then((value) =>
        emaild = Provider.of<Auth>(context, listen: false).emaildata);
    await Provider.of<Restaurants>(context, listen: false)
        .fetchRestaurant()
        .then((value) =>
            _m = Provider.of<Restaurants>(context, listen: false).rest);
    setState(() {
      m = _m;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Image imageFromBase64String(String base64String) {
    return Image.memory(base64Decode(base64String));
  }

  @override
  Widget build(BuildContext context) {
    // final emaild = Provider.of<Auth>(context, listen: false);
    // final uemail = emaild.emaildata;
    //final restaurant =
    // final rest = Provider.of<Restaurants>(context, listen: false).rest;

    // final _restaurant = ModalRoute.of(context).settings.arguments as Restaurant;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: m == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                SafeArea(
                  child: SizedBox(
                    height: Helper.getScreenHeight(context),
                    width: Helper.getScreenWidth(context),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            ClipOval(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 150,
                                    width: 150,
                                    child: Image(
                                      fit: BoxFit.cover,
                                      image:
                                          imageFromBase64String(m['imageUrl'])
                                              .image,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    child: Container(
                                      height: 30,
                                      width: 150,
                                      color: Colors.black.withOpacity(0.6),
                                      child: Image.asset("images/camera.png"),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.edit, //color: Colors.deepOrange,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                GestureDetector(
                                  child: const Text(
                                    "Edit Profile",
                                    style: TextStyle(color: AppColor.orange),
                                  ),
                                  onTap: () => Navigator.of(context)
                                      .pushNamed(HomePage.routeName),
                                ),
                              ],
                            ),
                            // const Center(
                            //   child: Text('Your profile'),
                            // ),
                            const SizedBox(
                              height: 40,
                            ),
                            CustomFormImput(
                              label: "Name",
                              value: "${m['name']}",
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomFormImput(
                              label: "Email",
                              value: emaild,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomFormImput(
                              label: "Mobile No",
                              value: m['phone'],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomFormImput(
                              label: "Address",
                              value: m['address'],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            // const CustomFormImput(
                            //   label: "Password",
                            //   value: "Emilia Clarke",
                            //   isPassword: true,
                            // ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            // const CustomFormImput(
                            //   label: "Confirm Password",
                            //   value: "Emilia Clarke",
                            //   isPassword: true,
                            // ),
                            // const SizedBox(
                            //   height: 20,
                            // ),
                            const SizedBox(
                              height: 50,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Back"),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class CustomFormImput extends StatelessWidget {
  const CustomFormImput({
    Key key,
    String label,
    String value,
    bool isPassword = false,
  })  : _label = label,
        _value = value,
        _isPassword = isPassword,
        super(key: key);

  final String _label;
  final String _value;
  final bool _isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      padding: const EdgeInsets.only(left: 40),
      decoration: const ShapeDecoration(
        shape: StadiumBorder(),
        color: AppColor.placeholderBg,
      ),
      child: TextFormField(
        decoration: InputDecoration(
          border: InputBorder.none,
          labelText: _label,
          contentPadding: const EdgeInsets.only(
            top: 10,
            bottom: 10,
          ),
        ),
        obscureText: _isPassword,
        initialValue: _value,
        style: const TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }
}
