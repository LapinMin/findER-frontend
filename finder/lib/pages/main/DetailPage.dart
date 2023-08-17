import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class DetailPage extends StatefulWidget {
  String name;
  String distance;
  String address;
  String tel;
  String arriveTime;
  int numberOfBeds;

  DetailPage({
    super.key,
    required this.name,
    required this.distance,
    required this.address,
    required this.tel,
    required this.arriveTime,
    required this.numberOfBeds,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Color elementColor = Color(0xFF787878);
  final Color bedColor = Color(0xFFFF0000);
  int segmentedControlValue = 0;
  Set<Marker> markers = {}; // 마커 변수
  var vh = 0.0;
  var vw = 0.0;
  var name = "한성대학교";
  var lat = 37.582620285171856;
  var lon = 127.00819672835458;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    vh = MediaQuery.of(context).size.height;
    vw = MediaQuery.of(context).size.width;
  }

  Future<void> openKaKaoMap({
    required String name,
    required double lat,
    required double lon
    }) async {
    var _url = 'https://map.kakao.com/link/to/$name,$lat,$lon';
    Uri url = Uri.parse(_url);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  String convertPhoneNumber(String phoneNumber) {
    return phoneNumber.replaceAll('-', '');
  }

  void launchCaller(String phoneNumber) async {
    String url = 'tel:$phoneNumber';
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 1,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            "${widget.name}",
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
            ),
          ),
          leading: IconButton(
            color: Colors.black,
            icon: Icon(
              Icons.chevron_left
            ),
            onPressed: (){
              Navigator.of(context).pop();
            },
            iconSize: 30,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: vh * 0.4,
                child: KakaoMap(
                  onMapCreated: ((controller) async {
                    KakaoMapController mapController = controller;
                    mapController.setCenter(LatLng(37.3608681, 126.9306506));
                    markers.add(
                      Marker(
                        markerId: UniqueKey().toString(),
                        latLng: LatLng(37.3608681, 126.9306506),                          
                      )
                    );
                    setState(() {});
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 20,
                              color: elementColor,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${widget.address}",
                              style: TextStyle(
                                color: elementColor,
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'assets/images/kakao_navi.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.contain,
                            ),
                          ),
                          onTap: (){
                            openKaKaoMap(
                              name: name,
                              lat: lat,
                              lon: lon
                            );
                          },
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 20,
                          color: elementColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "신촌역 인근",
                          style: TextStyle(
                            color: elementColor,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.call,
                          size: 20,
                          color: elementColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        InkWell(
                          onTap: () => launchCaller(convertPhoneNumber(widget.tel)),
                          child: Text(
                            "${widget.tel}",
                            style: TextStyle(
                              color: elementColor,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.call,
                          size: 20,
                          color: elementColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          "잔여 병상 수",
                          style: TextStyle(
                            color: elementColor,
                          ),
                        ),
                        SizedBox(
                          width: 9,
                        ),
                        Text(
                          "${widget.numberOfBeds}",
                          style: TextStyle(
                            color: bedColor,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      height: vh * 0.13,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            "현위치에서 ${widget.name}까지는",
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("${widget.distance}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3469F0),
                                ),
                              ),
                              Text(
                                " 거리에 있으며, 예상 도착 시간은",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${widget.arriveTime}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF3469F0),
                                ),
                              ),
                              Text(
                                " 입니다.",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: vw * 0.6,
                      child: CupertinoSegmentedControl<int>(
                      selectedColor: Color(0xFF3469F0),
                      borderColor: Colors.white,
                      children: {
                        0: Text('병원 정보'),
                        1: Text('병상 추이'),
                      },
                      onValueChanged: (int val) {
                        setState(() {
                          segmentedControlValue = val;
                        });
                      },
                      groupValue: segmentedControlValue,
                      ),
                    ),
                    segmentedControlValue == 0 ? 
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [               
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "당직의 직통 연락처",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 7, top: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    size: 20,
                                    color: elementColor,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "02-0000-0000",
                                    style: TextStyle(
                                      color: elementColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "소아당직의 직통 연락처",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 7, top: 10),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.call,
                                    size: 20,
                                    color: elementColor,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "02-0000-0000",
                                    style: TextStyle(
                                      color: elementColor,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "구급차 가용 여부",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 7, top: 10),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/ambulance.svg',
                                    width: 20,
                                    height: 20,
                                    colorFilter: ColorFilter.mode(Color(0xFF3469F0), BlendMode.srcIn),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "구급차 가용 가능",
                                    style: TextStyle(
                                      color: Color(0xFF3469F0),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "CT, MRI 가용 여부",
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "CT",
                                        style: TextStyle(
                                          color: Color(0xFF3469F0),
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "MRI",
                                        style: TextStyle(
                                          color: Color(0xFFFF0000),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 15),
                                  Column(
                                    children: [
                                      Text(
                                        "O",
                                        style: TextStyle(
                                          color: Color(0xFF3469F0),
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "X",
                                        style: TextStyle(
                                          color: Color(0xFFFF0000),
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    :
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "최근",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        "4",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF3469F0),
                                        ),
                                      ),
                                      Text(
                                        "시간 중 병상을 이용 가능했던 시간은",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "3시간 30분",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF3469F0),
                                        ),
                                      ),
                                      Text(
                                        " 입니다.",
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 0.4 * vh,
                              width: 0.9 * vw,
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.green,
                              ),
                              child: Center(
                                child: Text("시간 그래프 부분"),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 40),
                              child: Text(
                                "최근 일주일간 평균 병상 추이",
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Container(
                              height: 0.4 * vh,
                              width: 0.9 * vw,
                              margin: EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Colors.red,
                              ),
                              child: Center(
                                child: Text("최근 일주일간 평균 병상 추이 부분"),
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
      ),
    );
  }
}