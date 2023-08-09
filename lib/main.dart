import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var controller = TextEditingController();
  bool enabled = false;
  List<Score> score = [];
  double rate = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    score.add(Score(rate: 5, comment: '맛나요'));
  }

  @override
  Widget build(BuildContext context) {
    var listView = ListView.builder(
      itemBuilder: (context, index) => ListTile(
        leading: Text('${score[index].rate}'),
        title: Text(score[index].comment),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            RatingBar.builder(
              initialRating: 3,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (value) {
                setState(() {
                  rate = value;
                  enabled = true;
                });
                print(value);
              },
            ),
            TextFormField(
              controller: controller,
              enabled: enabled,
              decoration: const InputDecoration(
                hintText: '한마디 해줘',
                label: Text('??'),
                border: OutlineInputBorder(),
              ),
              maxLength: 30,
            ),
            ElevatedButton(
              onPressed: enabled
                  ? () {
                      score.add(
                        Score(rate: rate, comment: controller.text),
                      );
                      setState(() {
                        listView;
                        enabled = false;
                      });
                    }
                  : null,
              child: const Text('저장하기'),
            ),
            Expanded(child: listView)
          ],
        ),
      ),
    );
  }
}

class Score {
  double rate;
  String comment;
  Score({required this.rate, required this.comment});
}
