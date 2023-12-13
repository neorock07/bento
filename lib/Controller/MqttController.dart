import 'dart:developer';

import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttController extends GetxController {
  // String server = "test.mosquitto.org";
  var isLoad = false.obs;
  var payloadMsg = "".obs;

  final MqttServerClient client = MqttServerClient("test.mosquitto.org", "");

  Future<void> connect() async {
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.onDisconnected = () => Get.snackbar("disconnect", "koneksi gagal");
    client.onConnected = () => Get.snackbar("Connected", "berhasil connect");
    client.onSubscribed =
        (topic) => Get.snackbar("onSubscribe", "Subscribe on $topic topic");
    client.pongCallback = () => log("Ping invoked");

    final connMsg = MqttConnectMessage()
        .withClientIdentifier("soekarno_soeharto")
        .startClean()
        .withWillTopic('willtopic')
        .withWillMessage('Will message')
        .withWillQos(MqttQos.atLeastOnce);
    client.connectionMessage = connMsg;
    try {
      log("iki ancuk i");
      await client.connect();
      subscribe("ganyang/cukong/sialan/data");

      publish("ganyang/cukong/sialan/data", payloadMsg.value);
    } catch (e) {
      client.disconnect();
      throw Exception("can't connect");
    }
  }

  void subscribe(String topic) {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      isLoad.value = false;
      client.subscribe(topic, MqttQos.atLeastOnce);
      Get.snackbar("success subscribe ", "connected to $topic topic");
      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
        payloadMsg.value =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      });
      // return opo;
    } else if (client.connectionStatus!.state ==
        MqttConnectionState.connecting) {
      isLoad.value = true;
      Get.snackbar("gagal subscribe ", "gagal connect to $topic topic");
      // return "";
    } else if (client.connectionStatus!.state ==
        MqttConnectionState.disconnected) {
      Get.snackbar("disconnected ", "disconnect to $topic topic");
      client.disconnect();
      // return "";
    }
  }

  void publish(String topic, String msg) {
    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(msg);
      client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      Get.snackbar("publish data", "success publish data to $topic topic");
    }else{
      Get.snackbar("gagal publish data", "gagal publish data to $topic topic");

    }
  }
}
