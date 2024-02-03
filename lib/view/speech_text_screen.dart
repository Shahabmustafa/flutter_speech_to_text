import 'package:avatar_glow/avatar_glow.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
class SpeechTextScreen extends StatefulWidget {
  const SpeechTextScreen({super.key});

  @override
  State<SpeechTextScreen> createState() => _SpeechTextScreenState();
}

class _SpeechTextScreenState extends State<SpeechTextScreen> {
  stt.SpeechToText? _speech;
  bool _isLesting = false;
  String text = "Press the button and start speaking";
  double _confindence = 1.0;

  showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _speech = stt.SpeechToText();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Speech To Text"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade200,
              ),
              child: Center(
                child: TextHighlight(
                  text: text,
                  words: {},
                  textAlign: TextAlign.center,
                  textStyle: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            GestureDetector(
              onTap: (){
                FlutterClipboard.copy(
                  text,
                ).then((value){
                  showToast("Copyed");
                }
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.copy),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AvatarGlow(
        animate: _isLesting,
        glowColor: Colors.red,
        duration: Duration(milliseconds: 2000),
        repeat: true,
        child: FloatingActionButton(
          onPressed: (){
            _listen();
          },
          child: Icon(_isLesting ? Icons.mic : Icons.mic_none),
        ),
      ),
    );
  }
  void _listen() async {
    if (!_isLesting) {
      bool available = await _speech!.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isLesting = true);
        _speech!.listen(
          onResult: (val) => setState(() {
            text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              _confindence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isLesting = false);
      _speech!.stop();
    }
  }
}
