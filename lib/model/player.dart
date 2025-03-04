
import '../reflection.dart';
import 'mob.dart';

@reflectable
class Player extends Mob{
  int _exp = 0;
  int get exp => _exp;

  Player({required super.name, required super.hp, required super.atk, super.level});

  void killed(Mob mob){
    _exp += (10 * mob.level * 0.1).round();
  }

  void levelUp(){
    level ++;
  }

  @override
  void attack(Mob mob) {
    print('attack to ${mob.name}');
    mob.hp -= (atk * level * 0.05).round();
  }

  @override
  bool dead() {
    if(hp <= 0){
      print('$name was dead');
      return true;
    }
    return false;
  }
}