import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableText extends StatelessWidget {
  final List<List<String>> textList;
  ClickableText(this.textList);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          children: _getTextSpanList(),
        ),
      ),
    );
  }

  List<TextSpan> _getTextSpanList(){
    var textSpanList = <TextSpan>[];

    for(var text in textList){
      if(text[0] == "rich"){
        TextSpan textSpan =  TextSpan(
          text: text[1],
          style: TextStyle(color: Colors.blue),
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              launch(
                  '${text[2]}');
            },
        );
        textSpanList.add(textSpan);
      }
      else {
        TextSpan textSpan = TextSpan(
          text: text[1],
          style: TextStyle(color: Colors.black),
        );
        textSpanList.add(textSpan);
      }
    }
    return textSpanList;
  }
}