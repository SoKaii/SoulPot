import 'dart:io';

import 'package:battery_indicator/battery_indicator.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:soulpot/global/utilities/bluetooth_manager.dart';
import 'package:soulpot/global/utilities/wifi_manager.dart';
import 'package:soulpot/analyzers_viewer/widgets/analyzer_wifi_modifier.dart';
import 'package:soulpot/global/widgets/dropdown_wifi_picker.dart';
import 'package:sizer/sizer.dart';

import '../../models/Analyzer.dart';
import '../../global/utilities/theme.dart';

class AnalyzerDetailsDialog extends StatefulWidget {
  const AnalyzerDetailsDialog({Key? key, required Analyzer analyzer})
      : analyzer = analyzer,
        super(key: key);

  final Analyzer analyzer;

  @override
  State<AnalyzerDetailsDialog> createState() => _AnalyzerDetailsDialogState();
}

class _AnalyzerDetailsDialogState extends State<AnalyzerDetailsDialog> {
  bool _isOn = true;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        height: 50.h,
        width: 90.w,
        child: Padding(
          padding: EdgeInsets.all(1.h),
          child: Column(
            children: [
              Text(
                widget.analyzer.name,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Greenhouse",
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 1.h),
                child: Text(
                  _isOn ? "On" : "Off",
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Greenhouse",
                  ),
                ),
              ),
              Switch(
                value: _isOn,
                onChanged: (_) {
                  setState(() {
                    _isOn = !_isOn;
                  });
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                activeTrackColor: Colors.grey[300],
                activeColor: Colors.green,
                inactiveThumbColor: Colors.red,
                inactiveTrackColor: Colors.grey[300],
              ),
              Spacer(),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: BatteryIndicator(
                      batteryFromPhone: false,
                      batteryLevel: widget.analyzer.battery!,
                      style: BatteryIndicatorStyle.skeumorphism,
                      showPercentNum: true,
                      size: 3.w,
                      colorful: true,
                    ),
                  ),
                  Text(
                    "Charge de la batterie : ${widget.analyzer.battery} %",
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Greenhouse",
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2.w),
                        child: Icon(
                          Icons.wifi,
                          color: SoulPotTheme.SPGreen,
                        ),
                      ),
                      Text(
                        "Réseau wifi : ${widget.analyzer.wifiName}",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Greenhouse",
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 1.h),
                    child: ElevatedButton(
                      onPressed: () async {
                        var ssids = await getWifi();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AnalyzerWifiModifier(pSsids: ssids),
                        );
                      },
                      child: Text(
                        "Changer le réseau wifi",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontFamily: "Greenhouse",
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        primary: SoulPotTheme.SPPurple,
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 1.h),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 1.h),
                child: ElevatedButton(
                  onPressed: () async {},
                  child: Text(
                    "Supprimer ${widget.analyzer.name}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontFamily: "Greenhouse",
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    primary: SoulPotTheme.SPRed,
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> getWifi() async {
    List<String> tmpSSIDs = [];
    if (Platform.isAndroid) {
      tmpSSIDs = await WifiManager.scanForWifi(context);
    }
    return tmpSSIDs;
  }
}