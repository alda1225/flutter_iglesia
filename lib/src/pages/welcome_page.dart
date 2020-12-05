import 'package:flutter/material.dart';
import '../constant/constantes.dart';
import 'home_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.6), BlendMode.dstATop),
            image: AssetImage("assets/StartBackground.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Align(
                alignment: Alignment.topCenter,
              ),
            ),
            Container(
              color: Colors.black54,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: kToolbarHeight + 15),
                  Padding(
                    padding: const EdgeInsets.all(35),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Image.asset("assets/logo.png"),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 26, vertical: 16),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: "BIENVENIDO\n"+"\n",
                                    style:
                                        TextStyle(color: Color(0XFFFFBD73), fontWeight: FontWeight.bold,fontFamily: "Poppins",fontSize: 20)),
                                TextSpan(
                                  text: "No nos cansemos de hacer el bien," +
                                      " porque a su debido tiempo cosecharemos si no nos damos por vencidos.\n",
                                  style: Theme.of(context).textTheme.headline,
                                ),
                                TextSpan(
                                  text: "Gálatas 6:9 | NVI\n",
                                  style: Theme.of(context).textTheme.display2,
                                )
                              ],
                            ),
                          ),
                        ),
                        FittedBox(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(
                                builder: (context) {
                                  return HomePage();
                                },
                              ));
                            },
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 26, vertical: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: kPrimaryColor,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Text(
                                    "INCIAR",
                                    style: Theme.of(context)
                                        .textTheme
                                        .button
                                        .copyWith(
                                          color: Colors.black,
                                        ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.black,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
