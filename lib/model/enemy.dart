

import '../reflection.dart';
import 'mob.dart';

@reflectable
class Enemy extends Mob{

  Enemy({required super.name, required super.hp, required super.atk, required super.level});

  @override
  void attack(Mob mob) {
    print('$name: attack to ${mob.name}');
    mob.hp -= (atk * level * 0.01).round();
  }

  @override
  bool dead() {
    if(hp <= 0){
      return true;
    }
    return false;
  }
}