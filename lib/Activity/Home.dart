import 'package:ekaiot/Controller/MqttController.dart';
import 'package:ekaiot/Partials/CardIndikator.dart';
import 'package:ekaiot/Partials/TxtField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var mqttController = Get.put(MqttController());

  final _formKey = GlobalKey<FormState>();
  var usernameController = TextEditingController();
  var brokerController = TextEditingController();
  var passwdController = TextEditingController();
  var payloadController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Eka-IoT",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(5, 15, 26, 1),
      ),
      backgroundColor: const Color.fromRGBO(23, 24, 26, 1),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                // height: MediaQuery.of(context).size.height * 0.22,
                decoration: BoxDecoration(
                    color: const Color.fromRGBO(16, 27, 43, 1),
                    borderRadius: BorderRadius.circular(10.h)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Indikator",
                      style: TextStyle(
                          color: Colors.grey,
                          fontFamily: "Inria",
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        // Obx(() => (mqttController.payloadMsg.value
                        //             .split(",")
                        //             .length >=
                        //         4)
                        //     ?
                        Obx(() => CardIndikator(context,
                            width: 150.w,
                            height: 50.h,
                            icon: Icons.thermostat,
                            iconColor: Colors.orange,
                            label: "Suhu",
                            value: "${mqttController.suhu.value}")),
                        // : const CircularProgressIndicator()),
                        // Obx(() => (mqttController.payloadMsg.value
                        //             .split(",")
                        //             .length >=
                        //         4)
                        //     ?
                        Obx(() => CardIndikator(context,
                            width: 150.w,
                            height: 50.h,
                            icon: Icons.waves,
                            value: "${mqttController.humidity.value}",
                            label: "Humidity",
                            iconColor: Colors.deepOrange)),
                        // : const CircularProgressIndicator()),
                      ],
                    ),
                    SizedBox(
                      height: 6.h,
                    ),
                    Obx(() => Padding(
                          padding: EdgeInsets.only(left: 10.w),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.flag_circle,
                                color: Colors.red,
                              ),
                              SizedBox(width: 5.w),
                              Text(
                                  (mqttController.isConnect.value == true)
                                      ? "Connected"
                                      : "Disconnected",
                                  style: const TextStyle(color: Colors.white))
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 10.h,
                    )
                  ],
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                child: Column(
                  children: [
                    TxtField(context,
                        key: _formKey,
                        label: "Broker Address",
                        keyboardType: TextInputType.emailAddress,
                        controller: brokerController),
                    TxtField(context,
                        key: _formKey,
                        label: "Username",
                        keyboardType: TextInputType.name,
                        controller: usernameController),
                    TxtField(context,
                        key: _formKey,
                        label: "Password",
                        keyboardType: TextInputType.name,
                        controller: passwdController),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: TxtField(context,
                              key: _formKey,
                              label: "Payload",
                              keyboardType: TextInputType.name,
                              controller: payloadController),
                        ),
                        ElevatedButton(onPressed: () {
                           mqttController.publish("/UAS-IOT/43321206/STATUS", "1"); 
                        }, child: Text("Push")),
                        ElevatedButton(onPressed: () {
                           mqttController.publish("/UAS-IOT/43321206/STATUS", "0"); 

                        }, child: Text("Stop")),
                      ],
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ElevatedButton(
                            onPressed: () {
                              mqttController.serverName = brokerController.text;
                              mqttController.inisiasi();
                              (usernameController.text != null)
                                  ? 
                                  mqttController.connect(
                                      username: usernameController.text,
                                      password: passwdController.text)
                                  : "";
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.purple,
                            ),
                            child: const Text(
                              "Connect",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.45,
                          child: ElevatedButton(
                            onPressed: () {
                              mqttController.disconnect();
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.grey,
                            ),
                            child: const Text(
                              "Disconnect",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
