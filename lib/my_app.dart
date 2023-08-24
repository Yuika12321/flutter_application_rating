import 'package:flutter/material.dart';
import 'meal_api.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var controller = TextEditingController();
  bool enabled = false;

  double rate = 0;
  String now = '날짜를 선택하세요';
  dynamic listView = const Text('결과출력화면');
  void showReview({required String evalDate}) {
    var api = MealApi();
    var result = api.getReview(evalDate: evalDate);
    setState(() {
      listView = FutureBuilder(
        future: result,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // 데이터 있음
            var data = snapshot.data;
            // data = [ { 'rating':4, 'comment": 'hello'}, ,,,,,,]
            return ListView.separated(
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(data[index]['rating']),
                    title: Text(data[index]['comment']),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
                itemCount: data.length);
          } else {
            // 데이터 없음 -- 대기 중 . . .
            return const Center(child: CircularProgressIndicator());
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () async {
                  var dt = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2023),
                      lastDate: DateTime.now());
                  if (dt != null) {
                    var date = dt.toString().split(' ')[0];
                    setState(() {
                      now = date;
                    });
                    showReview(evalDate: date);
                  }
                },
                child: Text(now)),
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
              },
            ),
            TextFormField(
              validator: (value) {
                if (value.toString().trim().isEmpty) {
                  return 'space';
                }
                return null;
              },
              controller: controller,
              enabled: enabled,
              decoration: const InputDecoration(
                hintText: '한마디 해주세요',
                label: Text('여긴뭘까?'),
                border: OutlineInputBorder(),
              ),
              maxLength: 30,
            ),
            ElevatedButton(
              onPressed: enabled
                  ? () async {
                      var api = MealApi();
                      //2023-08-16 16:55:45
                      var res = await api.insert(now, rate, controller.text);
                      showReview(evalDate: now);
                    }
                  : null,
              child: const Text('저장하기'),
            ),
            Expanded(child: listView),
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
