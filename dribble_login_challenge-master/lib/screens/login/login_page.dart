import 'package:flutter/material.dart';
import 'package:login_dribble_challenge/components/forward_button.dart';
import 'package:login_dribble_challenge/components/header_text.dart';
import 'package:login_dribble_challenge/components/trapozoid_cut_colored_image.dart';
import 'package:login_dribble_challenge/screens/login/login_animation.dart';
import 'package:login_dribble_challenge/utility/app_constant.dart';
import 'package:login_dribble_challenge/utility/color_utility.dart';
import 'dart:async';
import 'package:login_dribble_challenge/appservice/apiservice.dart';
abstract class GoToWelcomeListener {
  void onGoToWelcomeTap();
}

class LoginPage extends StatelessWidget {
  LoginPage(
      {@required AnimationController controller,
      @required this.goToWelcomeListener})
      : enterAnimation = new LoginEnterAnimation(controller);

  final GoToWelcomeListener goToWelcomeListener;
  final LoginEnterAnimation enterAnimation;

  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: <Widget>[
        _trapoziodView(size, textTheme),
        _buttonContainer(size, textTheme,context),
      ],
    );
  }

  Widget _trapoziodView(Size size, TextTheme textTheme) {
    return Transform(
      transform: Matrix4.translationValues(
          0.0, -enterAnimation.Ytranslation.value * size.height, 0.0),
      child: TrapozoidTopBar(
          child: Container(
        height: size.height * 0.7,
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            _buildBackgroundImage(size),
            _buildTextHeader(size, textTheme),
            _buildForm(size, textTheme)
          ],
        ),
      )),
    );
  }

  Widget _buildForm(Size size, TextTheme textTheme) {
    return Padding(
        padding: EdgeInsets.only(top: size.height * 0.3, left: 24, right: 24),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: _buildTextFormUsername(textTheme),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1,
                      vertical: 12),
                  child: Container(
                    color: Colors.grey,
                    height: 1,
                    width: enterAnimation.dividerScale.value *
                        size.width,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1,
                  ),
                  child: _buildTextFormPassword(textTheme),
                )
              ],
            ),
          ),
        ));
  }

  Widget _buildTextFormUsername(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.userNameOpacity,
      child: TextFormField(
        style: textTheme
            .title
            .copyWith(color: Colors.black87, letterSpacing: 1.2),
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: PHONE_AUTH_HINT,
          hintStyle:
              textTheme.subhead.copyWith(color: Colors.grey),
          icon: Icon(
            Icons.person,
            color: Colors.black87,
          ),
          contentPadding: EdgeInsets.zero,
        ),
        keyboardType: TextInputType.text,
        controller: userNameController,
        validator: (val) => val.length == 0
            ? PHONE_AUTH_VALIDATION_EMPTY
            : val.length < 10 ? PHONE_AUTH_VALIDATION_INVALID : null,
      ),
    );
  }

  Widget _buildTextFormPassword(TextTheme textTheme) {
    return FadeTransition(
      opacity: enterAnimation.passowrdOpacity,
      child: TextFormField(
        style:textTheme
            .title
            .copyWith(color: Colors.black87, letterSpacing: 1.2),
        decoration: new InputDecoration(
            border: InputBorder.none,
            hintText: PASSWORD_AUTH_HINT,
            hintStyle:textTheme
                .subhead
                .copyWith(color: Colors.grey),
            contentPadding: EdgeInsets.zero,
            icon: Icon(Icons.lock, color: Colors.black87)),
        keyboardType: TextInputType.text,
        controller: passwordController,
        obscureText: true,
        validator: (val) => val.length == 0
            ? PHONE_AUTH_VALIDATION_EMPTY
            : val.length < 10 ? PHONE_AUTH_VALIDATION_INVALID : null,
      ),
    );
  }

  Widget _buttonContainer(Size size, TextTheme textTheme,BuildContext  context) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.8),
      child: Container(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // _buildSocialMediaAppButton(COLOR_GOOGLE, IMAGE_PATH_GOOGLE,
            //     40, enterAnimation.googleScaleTranslation.value),
            // SizedBox(
            //   width: 8,
            // ),
            // _buildSocialMediaAppButton(COLOR_FACEBOOK, IMAGE_PATH_FACEBOOK,
            //     48, enterAnimation.facebookScaleTranslation.value),
            // SizedBox(
            //   width: 8,
            // ),
            // _buildSocialMediaAppButton(COLOR_TWITTER, IMAGE_PATH_TWITTER,
            //     56, enterAnimation.twitterScaleTranslation.value),
            SizedBox(
              width: size.width * 0.1,
            ),
            Transform(
              transform: Matrix4.translationValues(
                  enterAnimation.translation.value * 200, 0.0, 0.0),
              child: ForwardButton(
                onPressed: () async{
                      final medicines = await ApiService.doctorlist();
                         
                          if (medicines == null) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content:
                                        Text('Check your internet connection'),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  );
                                });
                            return;
                          } else {
                            final userwithUsernameExists = medicines.any((u) =>
                                u['hospitalname'] ==
                                userNameController.text && u['password']==passwordController.text);
                            if (userwithUsernameExists) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Listmedicines(userNameController.text)));
                            } else {}
                          }
                },
                label: BUTTON_PROCEED,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildSocialMediaAppButton(
  //     String color, String image, double size, double animatedValue) {
  //   return Transform(
  //     alignment: Alignment.center,
  //     transform: Matrix4.diagonal3Values(animatedValue, animatedValue, 0.0),
  //     child: InkWell(
  //       onTap: null,
  //       child: Container(
  //         height: size,
  //         width: size,
  //         padding: const EdgeInsets.all(8.0),
  //         decoration: new BoxDecoration(
  //           shape: BoxShape.circle,
  //           color: Color(getColorHexFromStr(color)),
  //         ),
  //         child: Image.asset(image),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildBackgroundImage(Size size) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.3),
      child: Container(
        decoration: new BoxDecoration(
          shape: BoxShape.rectangle,
          image: DecorationImage(
              image: new AssetImage(IMAGE_LOGIN_PATH),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.overlay)),
        ),
      ),
    );
  }

  Widget _buildTextHeader(Size size, TextTheme textTheme) {
    return Transform(
      transform: Matrix4.translationValues(
          -enterAnimation.Xtranslation.value * size.width, 0.0, 0.0),
      child: Padding(
        padding: EdgeInsets.only(top: size.height * 0.15, left: 24, right: 24),
        child: HeaderText(text: TEXT_SIGN_IN_LABEL, imagePath: IMAGE_SLIPPER_PATH,),
      ),
    );
  }
}

// class Listdoctor extends StatelessWidget {


//   Widget build(BuildContext context) {
//     return Container(
//       child:Text('Hi there')
//     );
//   }
// }

class Listmedicines extends StatelessWidget {
  
  String hospitalname;
  Listmedicines(this.hospitalname);
  
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      // appBar: AppBar(
      //   title: Text('Doctors'),
      // ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: const FractionalOffset(0.1, 0.0),
                  end: const FractionalOffset(0.0, 1.5),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
            child: FutureBuilder(
              future: ApiService.getmedicinelist(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final medicines = snapshot.data;

                  return ListView.builder(
                    itemBuilder: (context, index) {
                      if (medicines[index]["hospitalname"]
                          .contains(hospitalname)) {
                        return Card(
                          color: Colors.transparent,
                          child: ListTile(
                              title: Text(
                                medicines[index]["medicinename"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),

                              // contentPadding: EdgeInsets.only(top: 10.0),
                              trailing: RaisedButton(
                                textColor: Colors.white,
                                color: Colors.blueAccent,
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Update',
                                  style: TextStyle(fontSize: 15.0),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40.0),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateMedicine(
                                              medicines[index]["medicinename"],
                                              medicines[index]
                                                  ["hospitalname"])));
                                },
                              ),
                              subtitle: Text(
                                medicines[index]["stock"] + " medicines",
                                style: TextStyle(
                                  color: Colors.white70,
                                ),
                              )),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        );
                        // Padding(
                        //   padding: EdgeInsets.only(top:100.0),
                        // child:new Container(
                        //   height: 50.0,
                        //   width: 10.0,
                        // ));
                      } else
                        return Container(
                            height: 0.0,
                            child: ListTile(
                                title: new Container(
                              height: 0.0,
                            )));
                    },
                    itemCount: medicines.length,
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ],
      ),
    ));
  }
}

class UpdateMedicine extends StatefulWidget {
  String medicinename;
  String hospitalname;
  UpdateMedicine(this.medicinename, this.hospitalname);
  _UpdateMedicineState createState() =>
      _UpdateMedicineState(medicinename, hospitalname);
}

class _UpdateMedicineState extends State<UpdateMedicine> {
  String medicinename;
  String hospitalname;

  _UpdateMedicineState(this.medicinename, this.hospitalname);

  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
          body: new Stack(
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    begin: const FractionalOffset(0.5, 0.0),
                    end: const FractionalOffset(0.0, 0.5),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              child: Center(
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 270.0),
                    ),
                    new SizedBox(
                      width: 300.0,
                      height: 40.0,
                      child: RaisedButton(
                        elevation: 20.0,
                        splashColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(
                              color: Colors.green[800], width: 3.0),
                        ),
                        color: Colors.green,
                        child: Text(
                          "Increase the medicine stock",
                          style: TextStyle(color: Colors.white,fontSize: 16.0),
                        ), 
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddMedicine(
                                      medicinename, hospitalname)));
                        },
                      ),
                    ),
                    // RaisedButton(
                    //   child: Text("Add to the medicine stock"),
                    //   onPressed: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) =>
                    //                 AddMedicine(medicinename, hospitalname)));
                    //   },
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 30.0),
                    ),
                    new SizedBox(
                      width: 300.0,
                      height: 40.0,
                      child: RaisedButton(
                        elevation: 20.0,
                        splashColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(
                              color: Colors.red[800], width: 3.0),
                        ),
                        color: Colors.red,
                        child: Text(
                          "Decrease the medicine stock",
                          style: TextStyle(color: Colors.white,fontSize: 16.0),
                        ), 
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DecrementMedicine(
                                      medicinename, hospitalname)));
                        },
                      ),
                    )
                  ],
                ),
              )),
        ],
      )),
    );
  }
}

class AddMedicine extends StatefulWidget {
  String medicinename;
  String hospitalname;
  AddMedicine(this.medicinename, this.hospitalname);
  _AddMedicineState createState() =>
      _AddMedicineState(medicinename, hospitalname);
}

class _AddMedicineState extends State<AddMedicine> {
  String medicinename;
  String hospitalname;

  _AddMedicineState(this.medicinename, this.hospitalname);
  Widget build(BuildContext context) {
    var count;
    TextEditingController _increasecount = new TextEditingController();
    _DecrementMedicineState(this.medicinename, this.hospitalname);
    
      return MaterialApp(
        home: new Scaffold(
          body: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                new Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image:
                            new AssetImage('android/assets/images/adding.gif'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              // TextField(
              //   controller: _increasecount,
              //   decoration: InputDecoration(
              //     hintText: 'Increase stock',
              //   ),
              // ),
              TextField(
              decoration: new InputDecoration(
                        labelText: "Enter the count to be increased",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
              controller: _increasecount,
              
            ),
            Padding(
              padding: EdgeInsets.only(top:30.0)
            ),
              new SizedBox(
                width: 300.0,
                      height: 40.0,
                      child: RaisedButton(
                 elevation: 20.0,
                        splashColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(
                              color: Colors.blueAccent, width: 3.0),
                        ),
                        color: Colors.blueAccent,
                child: Text('Update'),
                onPressed: () {
                  final increase = {
                    'count': _increasecount.text.toString(),
                    'hospitalname': hospitalname,
                    'medicine': medicinename,
                  };
                  ApiService.increaseStock(increase).then((success) {
                    String title, text;
                    if (!success) {
                      title = "Error";
                      text = "Please try again !";
                      showDialog(
                          builder: (context) => AlertDialog(
                                title: Text(title),
                                content: Text(text),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK'))
                                ],
                              ),
                          context: context);
                    }

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Listmedicines(hospitalname)));
                  }); 
                },
              ),
              ),
              
            ],
          ),
        ),
      );
    }
  }


class DecrementMedicine extends StatefulWidget {
  String medicinename;
  String hospitalname;
  DecrementMedicine(this.medicinename, this.hospitalname);
  _DecrementMedicineState createState() =>
      _DecrementMedicineState(medicinename, hospitalname);
}

class _DecrementMedicineState extends State<DecrementMedicine> {
  String medicinename;
  String hospitalname;
  var count;
  TextEditingController _decreasecount = new TextEditingController();
  _DecrementMedicineState(this.medicinename, this.hospitalname);
  Widget build(BuildContext context) {
    return MaterialApp(
      home: new Scaffold(
        body:SingleChildScrollView(

            child: new Column(
          children: <Widget>[
            Padding(
              padding:  EdgeInsets.only(top:100.0),
            ),
            new Container(
                    height: 200.0,
                    width: 200.0,
                    decoration: new BoxDecoration(
                      image: new DecorationImage(
                        image:
                            new AssetImage('android/assets/images/reading.gif'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
              padding:  EdgeInsets.only(top:40.0),
            ),
            TextField(
              decoration: new InputDecoration(
                        labelText: "Enter the count to be decreased",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(25.0),
                          borderSide: new BorderSide(
                          ),
                        ),
                        //fillColor: Colors.green
                      ),
              controller: _decreasecount,
              
            ),
              Padding(
              padding:  EdgeInsets.only(top:50.0),
            ),
            new SizedBox(
            width: 300.0,
                      height: 40.0,
              child: RaisedButton(
                elevation: 20.0,
                        splashColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40.0),
                          side: BorderSide(
                              color: Colors.blueAccent, width: 3.0),
                        ),
                        color: Colors.blueAccent,
              child: Text('Update stock'),

              onPressed: () {
                final decrease = {
                  'count': _decreasecount.text.toString(),
                  'hospitalname': hospitalname,
                  'medicine': medicinename,
                };
                ApiService.decreseStock(decrease).then((success) {
                  String title, text;
                  if (!success) {
                    title = "Error";
                    text = "Please try again !";
                    showDialog(
                        builder: (context) => AlertDialog(
                              title: Text(title),
                              content: Text(text),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'))
                              ],
                            ),
                        context: context);
                  }

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Listmedicines(hospitalname)));
                });
              },
            ),
            ),
            
            
          ],
        )),
      ),
    );
  }
}
