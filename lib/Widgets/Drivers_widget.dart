import 'package:flutter/material.dart';

class DriversWidget extends StatelessWidget {
  const DriversWidget(
      {super.key,
        required this.Driver_name,
        required this.Team_name,
        required this.country_code,
        required this.color,
        required this.Driver_image
      }
      );
 final String Driver_name ;
final String Team_name;
final String country_code;
final String Driver_image;
final  Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Card(
            color: color,
            margin: const EdgeInsets.all(20),
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
                height: 170,
                alignment: Alignment.center,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$Driver_name",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        "$Team_name",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 30,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("$country_code",style: TextStyle(
                              color: Colors.white
                            ),)
                          ],
                        ),
                      )
                    ]
                )
            ),
          ),
          Positioned(
            left: -17,
            top: 43,
            child: Container(
              width: 120,
              height: 120,
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(Driver_image),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
