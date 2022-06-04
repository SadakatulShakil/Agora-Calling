import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_vedio_call/pages/call.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class IndexPage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => InitState();

}
class InitState extends State<IndexPage> {

  final _channelController = TextEditingController();
  bool _validateError  = false;
  ClientRole? _role = ClientRole.Broadcaster;

  @override
  void dispose() {
    // TODO: implement dispose
    _channelController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: const Color(0xFF00A6FF),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Video Call Service',),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 40,),
              Padding(
                padding: const EdgeInsets.only(left: 50.0),
                child: Image.network('https://tinyurl.com/2p889y4k'),
              ),
            const SizedBox(height: 20,),
            TextField(
              controller: _channelController,
              decoration: InputDecoration(
                errorText: _validateError ? 'channel name is mandatory':null,
                border: UnderlineInputBorder(
                  borderSide: BorderSide(width: 1)
                ),
                hintText: 'Channel name'
              ),
            ),
            RadioListTile(
              title: Text('Broadcaster'),
              onChanged: (ClientRole? value){
                setState(() {
                  _role = value;
                });
              },
              value: ClientRole.Broadcaster,
              groupValue: _role,
            ),
            RadioListTile(
              title: Text('Audience'),
              onChanged: (ClientRole? value){
                setState(() {
                  _role = value;
                });
              },
              value: ClientRole.Audience,
              groupValue: _role,
            ),
            ElevatedButton(
                onPressed: onJoin,
                child: Text('Join'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 40)
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> onJoin() async{
    setState(() {
      _channelController.text.isEmpty?
      _validateError = true:
      _validateError = false;
    });
    if(_channelController.text.isNotEmpty) {
      PermissionStatus microphone = await Permission.microphone.request();
      PermissionStatus camera = await Permission.camera.request();
      if (microphone == PermissionStatus.granted &&
          camera == PermissionStatus.granted) {
        await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
                CallPage(_channelController.text, _role)));
      }
    }
  }
}