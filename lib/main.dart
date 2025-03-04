import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'main.reflectable.dart';
import 'model/enemy.dart';
import 'model/player.dart';

void main() {
  initializeReflectable();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Player player;
  late Enemy enemy1;
  late Enemy enemy2;
  bool _playerTurn = true;
  Timer? _enemyTimer;

  @override
  void initState() {
    super.initState();
    player = Player(name: "player",hp: 100, atk: 120, level: 1);
    enemy1 = Enemy(name: "bunny1", hp: 100, atk: 50, level: 1);
    enemy2 = Enemy(name: "bunny2",hp: 100, atk: 50, level: 1);
    print(player.toString());
    print(enemy1.toString());
    print(enemy2.toString());
    _enemyTimer = Timer.periodic(Duration(seconds: 2), (timer){
      if(_playerTurn == false){
        if(enemy1.dead() == false){
          enemy1.attack(player);
        }
        if(enemy2.dead() == false){
          enemy2.attack(player);
        }
        _playerTurn = true;
        setState(() {});
      }
      if(enemy1.dead() && enemy2.dead()){
        print('player win');
        player.killed(enemy1);
        player.killed(enemy2);
        player.levelUp();
        print('player level up');
        print(player.toString());
        _playerTurn = false;
        setState(() {});
        _enemyTimer!.cancel();
      }
      if(player.dead()){
        print('player lose');
        _playerTurn = false;
        setState(() {});
        _enemyTimer!.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _enemyTimer!.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text('LV${player.level}. ${player.name}\nHP. ${player.hp}',),
               SizedBox(height: 10),
               Icon(Icons.directions_walk_sharp, size: 72,),
               SizedBox(height: 10),
               ElevatedButton(onPressed: _playerTurn ? ()
               {
                 int rand = Random().nextInt(2);
                 if(rand == 0){
                   if(enemy1.dead()){
                     player.attack(enemy2);
                   }
                   else{
                     player.attack(enemy1);
                   }
                 }
                 if(rand == 1){
                   if(enemy2.dead()){
                     player.attack(enemy1);
                   }
                   else{
                     player.attack(enemy2);
                   }
                 }
                 _playerTurn = false;
                 setState(() {});
               } : null, child: Text("공격")),
            ],
          ),
          SizedBox(width: 32,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!enemy1.dead())...[
                Text('LV${enemy1.level}. ${enemy1.name}\nHP. ${enemy1.hp}'),
                SizedBox(height: 10),
                Icon(Icons.cruelty_free_outlined, size: 48,),
              ]
            ],
          ),
          SizedBox(width: 32,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if(!enemy2.dead())...[
                Text('LV${enemy2.level}. ${enemy2.name}\nHP. ${enemy2.hp}'),
                SizedBox(height: 10),
                Icon(Icons.cruelty_free_outlined, size: 48,),
              ]
            ],
          )
        ],
      ),
    );
  }
}
