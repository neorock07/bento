import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttController extends GetxController {
  // String server = "test.mosquitto.org";
  var isLoad = false.obs;
  var payloadMsg = "".obs;
  var isConnect = false.obs;
  var suhu = "".obs;
  var humidity = "".obs;
  String? serverName;

  MqttServerClient? client;
  // MqttServerClient client = MqttServerClient(serverName!, "");
  void inisiasi() {
      (serverName != null)? client = MqttServerClient(serverName!, "") : "";
  }

  Future<void> connect({String? username, String? password}) async {
    client!.logging(on: true);
    client!.keepAlivePeriod = 120;
    client!.onDisconnected = () => Get.snackbar("disconnect", "koneksi gagal", colorText: Colors.white);
    client!.onConnected = () => Get.snackbar("Connected", "berhasil connect", colorText: Colors.white);
    client!.onSubscribed =
        (topic) => Get.snackbar("onSubscribe", "Subscribe on $topic topic");
    client!.pongCallback = () => log("Ping invoked");

    final connMsg = MqttConnectMessage()
        .withClientIdentifier("soekarno_soeharto")
        .startClean()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .withWillQos(MqttQos.atLeastOnce);
    client!.connectionMessage = connMsg;
    try {
      log("iki ancuk i");
      await client!.connect(username,password);
      isConnect.value = true;
      subscribe();

      // publish("ganyang/cukong/sialan/data", payloadMsg.value);
    } catch (e) {
      client!.disconnect();
      isConnect.value = false;
      throw Exception("can't connect");
    }
  }

  void disconnect() async {
      client!.disconnect();
      isConnect.value = false;
  }



  void subscribe() async{
    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      isLoad.value = false;
      client!.subscribe("/UAS-IOT/43321206/SUHU", MqttQos.atLeastOnce);
      client!.subscribe("/UAS-IOT/43321206/KELEMBABAN", MqttQos.atLeastOnce);
      Get.snackbar("success subscribe ", "connected to SUHU topic", colorText: Colors.white);
      client!.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        payloadMsg.value =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
        final topic = c[0].topic;
        if(topic == "/UAS-IOT/43321206/SUHU"){
          suhu.value = payloadMsg.value;
        }else if(topic == "/UAS-IOT/43321206/KELEMBABAN"){
          humidity.value = payloadMsg.value;
        }
      });
      // return opo;
    } else if (client!.connectionStatus!.state ==
        MqttConnectionState.connecting) {
      isLoad.value = true;
      Get.snackbar("gagal subscribe ", "gagal connect to topic", colorText: Colors.white);
      // return "";
    } else if (client!.connectionStatus!.state ==
        MqttConnectionState.disconnected) {
      Get.snackbar("disconnected ", "disconnect to  topic");
      client!.disconnect();
      // return "";
    }
  }

  void publish(String topic, String msg) async {
    if (client!.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(msg);
      client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      Get.snackbar("publish data", "success publish data to $topic topic");
    }else{
      Get.snackbar("gagal publish data", "gagal publish data to $topic topic");

    }
  }
}
