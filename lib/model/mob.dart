
import 'package:reflaction/reflection.dart';

import '../string_util.dart';

@reflectable
abstract class Mob{
  late String _name;
  late int _hp;
  late int _atk;
  late int _level;

  Mob({required String name,required int hp, required int atk, int level = 1}):
    _name = name,
    _hp = hp,
    _atk = atk,
    _level = level;

  int get atk => _atk;
  set atk(int value) => _atk = value;
  int get hp => _hp;
  set hp(int value) => _hp = value;
  int get level => _level;
  set level(int level) => _level = level;
  String get name => _name;

  void attack(Mob mob);
  bool dead();

  @override
  String toString(){
    return StringUtil.toJsonString(this);
  }
}