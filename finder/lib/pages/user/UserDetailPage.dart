import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:http/http.dart';
import '../../models/modelsExport.dart';

class UserDetailPage extends StatelessWidget {
  final User user;

  UserDetailPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {

    final vw = MediaQuery.of(context).size.width;
    final vh = MediaQuery.of(context).size.height;

    String getFormedPhoneNum(String phoneNum) {
      return '${phoneNum.substring(0, 3)}-${phoneNum.substring(3, 7)}-${phoneNum.substring(7, 11)}';
    }

    Widget checkNoneText(String text) {
      if (text == "X") {
        return Text(
          '(해당 없음)',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey
          )
        );
      } else {
        return Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.black
          )
        );
      }
    }

    void launchCaller(String phoneNum) async {
      String url = 'tel:$phoneNum';
      if (await canLaunchUrlString(url)) {
        await launchUrlString(url);
      } else {
        throw 'Could not launch $url';
      }
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(
              Icons.chevron_left,
              size: 35,
              color: Colors.black,
              weight: 700
            ),
            onTap: () {
              Navigator.pop(context);
            }
          ),
          title: Text(
            user.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black
            )
          ),
          actions: [
            TextButton(
              child: Text(
                '편집',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 79, 112, 229),
                  fontSize: 16,
                )
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.zero,
                      ),
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero
                        ),
                        actionsPadding: EdgeInsets.only(bottom: 5.0),
                        title: Text('문진표 편집'),
                        content: Text('문진표를 편집하시겠습니까?'),
                        actions: [
                          TextButton(
                            child: Text(
                              '수정',
                              style: TextStyle(
                                color: Color.fromARGB(255, 79, 112, 229)
                              ),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.zero
                                    ),
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero
                                      ),
                                      actionsPadding: EdgeInsets.only(bottom: 5.0),
                                      title: Text('문진표 수정'),
                                      content: Text('문진표를 수정하시겠습니까?'),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            '수정',
                                            style: TextStyle(
                                              color: Color.fromARGB(255, 79, 112, 229)
                                            )
                                          ),
                                          onPressed: () {
                                            if (user.isLinked) {
                                              showDialog(
                                                context: context,
                                                builder: (context) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.zero
                                                    ),
                                                    child: AlertDialog(
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.zero
                                                      ),
                                                      actionsPadding: EdgeInsets.only(bottom: 5.0),
                                                      title: Text('알림'),
                                                      content: Text('타인의 문진표는 수정할 수 없습니다'),
                                                      actions: [
                                                        TextButton(
                                                          child: Text(
                                                            '확인',
                                                            style: TextStyle(
                                                              color: Colors.black
                                                            )
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(context);
                                                            Navigator.pop(context);
                                                          }
                                                        )
                                                      ]
                                                    )
                                                  );
                                                }
                                              );
                                            } else {

                                            }
                                          }
                                        ),
                                        TextButton(
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
                                              color: Colors.black
                                            )
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }
                                        )
                                      ],
                                    )
                                  );
                                }
                              );
                            }
                          ),
                          TextButton(
                            child: Text(
                              '삭제',
                              style: TextStyle(
                                color: Colors.red
                              )
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.zero
                                    ),
                                    child: AlertDialog(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero
                                      ),
                                      actionsPadding: EdgeInsets.only(bottom: 5.0),
                                      title: Text('문진표 삭제'),
                                      content: Text(
                                        user.isLinked
                                        ? '문진표를 삭제하시겠습니까?'
                                        : '연동을 취소하시겠습니까?'),
                                      actions: [
                                        TextButton(
                                          child: Text(
                                            '삭제',
                                            style: TextStyle(
                                              color: Colors.red
                                            )
                                          ),
                                          onPressed: () {
                                            if (user.isLinked) {
                                              
                                            } else {

                                            }
                                          }
                                        ),
                                        TextButton(
                                          child: Text(
                                            '취소',
                                            style: TextStyle(
                                              color: Colors.black
                                            )
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }
                                        )
                                      ]
                                    )
                                  );
                                }
                              );
                            }
                          ),
                          TextButton(
                            child: Text(
                              '취소',
                              style: TextStyle(
                                color: Colors.black
                              )
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }
                          )
                        ],
                      )
                    );
                  }
                );
              }
            )
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(0.3),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 0.3,
                  color: Colors.grey
                )
              )
            )
          )
        ),
        body: SafeArea(
          child: Container(
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: vh * 0.01, horizontal: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: vw * 0.02),
                              child: Text(
                                user.name,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              ),
                            ),
                            Text(
                              '${user.age}세 · (${user.gender})',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 18
                              )
                            ),
                            Container(
                              margin: EdgeInsets.only(left: vw * 0.02),
                              alignment: Alignment.center,
                              width: 45,
                              height: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.elliptical(5.0, 5.0)),
                                border: Border.all(
                                  width: 1.5,
                                  color: Color.fromARGB(255, 79, 112, 229)
                                ),
                                color: Colors.white
                              ),
                              child: Text(
                                user.familyRelations,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 79, 112, 229),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          width: 75,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 3,
                              color:Color.fromARGB(255, 213, 33, 20)
                            ),
                            borderRadius: BorderRadius.all(Radius.elliptical(6.0, 6.0)),
                            color: Colors.transparent,
                          ),
                          child: Text(
                            user.bloodType,
                            style: TextStyle(
                              color: Color.fromARGB(255, 213, 33, 20),
                              fontSize: 17,
                              fontWeight: FontWeight.bold
                            )
                          ),
                        )
                      ]
                    )
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vh * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.call_outlined,
                              color: Color.fromARGB(255, 79, 112, 229),
                              size: 25,
                              weight: 700
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                '전화번호',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(vw * 0.01, vh * 0.015, vw * 0.01, 0),
                          child: InkWell(
                            onTap: () => launchCaller(user.phoneNum),
                            child: Text(
                              getFormedPhoneNum(user.phoneNum),
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.grey,
                                color: Colors.grey,
                                fontSize: 16,
                              )
                            )
                          ),
                        )
                      ]
                    )
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.3,
                    color: Colors.grey
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vh * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/home.svg',
                              width: 25,
                              height: 25,
                              colorFilter: ColorFilter.mode(Color.fromARGB(255, 79, 112, 229), BlendMode.srcIn)
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                '주소',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(vw * 0.01, vh * 0.015, vw * 0.01, 0),
                          child: Text(
                            user.address,
                            style: TextStyle(
                              fontSize: 16
                            )
                          )
                        )
                      ]
                    )
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.3,
                    color: Colors.grey
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vh * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/allergy.svg',
                              width: 25,
                              height: 25,
                              colorFilter: ColorFilter.mode(Color.fromARGB(255, 79, 112, 229), BlendMode.srcIn)
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                '알러지 정보',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(vw * 0.01, vh * 0.015, vw * 0.01, 0),
                          child: checkNoneText(user.allergy)
                        )
                      ]
                    )
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.3,
                    color: Colors.grey
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vh * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/pill.svg',
                              width: 25,
                              height: 25,
                              colorFilter: ColorFilter.mode(Color.fromARGB(255, 79, 112, 229), BlendMode.srcIn)
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                '복용중인 약',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(vw * 0.01, vh * 0.015, vw * 0.01, 0),
                          child: checkNoneText(user.medicine)
                        )
                      ]
                    )
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.3,
                    color: Colors.grey
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vh * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/surgical.svg',
                              width: 25,
                              height: 25,
                              colorFilter: ColorFilter.mode(Color.fromARGB(255, 79, 112, 229), BlendMode.srcIn)
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                '최근 1년간 수술 이력',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(vw * 0.01, vh * 0.015, vw * 0.01, 0),
                          child: checkNoneText(user.surgery)
                        )
                      ]
                    )
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.3,
                    color: Colors.grey
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vw * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.liquor_outlined,
                              size: 25,
                              color: Color.fromARGB(255, 79, 112, 229),
                              weight: 700
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                '음주',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(vw * 0.01, vh * 0.015, vw * 0.01, 0),
                          child: checkNoneText(user.drinkingCycle)
                        )
                      ]
                    )
                  ),
                  Container(
                    width: double.infinity,
                    height: 0.3,
                    color: Colors.grey
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vh * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.smoking_rooms_outlined,
                              size: 25,
                              color: Color.fromARGB(255, 79, 112, 229),
                              weight: 700
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                '흡연',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(vw * 0.01, vh * 0.015, vw * 0.01, 0),
                          child: checkNoneText(user.smokingCycle)
                        )
                      ]
                    )
                  ),
                 Container(
                    width: double.infinity,
                    height: 0.3,
                    color: Colors.grey
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: vw * 0.03, vertical: vh * 0.01),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.more_horiz_outlined,
                              size: 25,
                              color: Color.fromARGB(255, 79, 112, 229),
                              weight: 700
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 3),
                              child: Text(
                                '기타 특이사항',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                )
                              )
                            )
                          ]
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(vw * 0.01, vh * 0.015, vw * 0.01, 0),
                          child: checkNoneText(user.etc)
                        )
                      ]
                    )
                  )
                ]
              ),
            ),
          ),
        )
      )
    );
  }
}