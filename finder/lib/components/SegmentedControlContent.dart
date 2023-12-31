import 'package:finder/components/componentsExport.dart';
import 'package:finder/models/hospitalDetailModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:finder/styles/Colors.dart';

class SegmentedControlContent extends StatefulWidget {
  final double vh;
  final double vw;
  final AsyncSnapshot<HospitalDetailModel> getHospitalDetailSnapshot;
  const SegmentedControlContent({
    required this.vw,
    required this.vh,
    required this.getHospitalDetailSnapshot
  });
  @override
  State<SegmentedControlContent> createState() => _SegmentedControlContentState();
}

class _SegmentedControlContentState extends State<SegmentedControlContent> {
  int segmentedControlValue = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: widget.vw * 0.6,
          child: CupertinoSegmentedControl<int>(
          selectedColor: themeColor,
          borderColor: Colors.white,
          children: {
            0: Text('응급실 정보'),
            1: Text('병상 추이'),
          },
          onValueChanged: (int val) {
            // 선택한 값 변경 시에만 상태 업데이트
            if (segmentedControlValue != val) {
              setState(() {
                segmentedControlValue = val;
              });
            }
          },
          groupValue: segmentedControlValue,
          ),
        ),
        segmentedControlValue == 0
        ?
          HospitalDetailInfo(
            getHospitalDetailSnapshot: widget.getHospitalDetailSnapshot,
          )
        :
          HospitalDetailTrendInfo(
            getHospitalDetailSnapshot: widget.getHospitalDetailSnapshot,
            vh: widget.vh,
            vw: widget.vw
          )
      ],
    );
  }
}