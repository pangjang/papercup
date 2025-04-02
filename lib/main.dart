import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '점심 메뉴 월드컵',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just valueㅇs: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const FoodWorldCup(),
    );
  }
}

class FoodWorldCup extends StatefulWidget {
  const FoodWorldCup({super.key});

  @override
  State<FoodWorldCup> createState() => _FoodWorldCupState();
}

class _FoodWorldCupState extends State<FoodWorldCup> {
  // 음식 메뉴 리스트
  final List<Food> foods = [
    Food(name: '김치찌개', imageUrl: 'assets/kimchi_stew.jpg'),
    Food(name: '비빔밥', imageUrl: 'assets/bibimbap.jpg'),
    Food(name: '돈까스', imageUrl: 'assets/tonkatsu.jpg'),
    Food(name: '짜장면', imageUrl: 'assets/jjajangmyeon.jpg'),
    Food(name: '라면', imageUrl: 'assets/ramen.jpg'),
    Food(name: '제육볶음', imageUrl: 'assets/jeyuk.jpg'),
    Food(name: '김밥', imageUrl: 'assets/kimbap.jpg'),
    Food(name: '샐러드', imageUrl: 'assets/salad.jpg'),
  ];

  List<Food> currentRound = [];
  List<Food> winners = [];
  int currentMatch = 0;

  @override
  void initState() {
    super.initState();
    currentRound = List.from(foods);
    currentRound.shuffle(); // 메뉴 순서를 랜덤하게 섞기
  }

  void selectWinner(Food winner) {
    setState(() {
      winners.add(winner);
      currentMatch++;

      // 현재 라운드가 끝났는지 확인
      if (currentMatch >= currentRound.length ~/ 2) {
        if (winners.length == 1) {
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text('우승 메뉴'),
                  content: Text('오늘의 점심 메뉴는 ${winner.name} 입니다!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          currentRound = List.from(foods);
                          currentRound.shuffle();
                          winners.clear();
                          currentMatch = 0;
                        });
                      },
                      child: const Text('다시하기'),
                    ),
                  ],
                ),
          );
        } else {
          // 다음 라운드 준비
          currentRound = List.from(winners);
          winners.clear();
          currentMatch = 0;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (currentRound.length < 2) return const Center(child: Text('게임 종료'));

    final food1 = currentRound[currentMatch * 2];
    final food2 = currentRound[currentMatch * 2 + 1];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${currentRound.length}강 ${currentMatch + 1}/${currentRound.length ~/ 2}',
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => selectWinner(food1),
                child: FoodCard(food: food1),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'VS',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => selectWinner(food2),
                child: FoodCard(food: food2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Food {
  final String name;
  final String imageUrl;

  Food({required this.name, required this.imageUrl});
}

class FoodCard extends StatelessWidget {
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              food.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.restaurant, size: 100);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              food.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
