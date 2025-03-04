

import 'package:reflaction/reflection.dart';
import 'package:reflectable/mirrors.dart';

class StringUtil{
  static const Set<Type> primitiveTypes = {int, double, String, bool, Enum};

  static bool isPrimitive(dynamic value) {
    return value == null || primitiveTypes.contains(value.runtimeType);
  }

  static String putIndent(int indentSize) {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < indentSize; i++) {
      sb.write("\t");
    }
    return sb.toString();
  }

  static List<MethodMirror> getAllGetters(ClassMirror classMirror) {
    List<MethodMirror> getters = [];

    while (classMirror != null) {
      getters.addAll(classMirror.declarations.values
          .whereType<MethodMirror>()
          .where((method) => method.isGetter && method.owner.simpleName.toString() != 'Object'));
      if (classMirror.superclass == null) break;
      classMirror = classMirror.superclass!;
    }
    return getters;
  }

  static String toJsonString(Object instance, {int indent=0}){
    StringBuffer sb = StringBuffer();
    InstanceMirror mirror = reflectable.reflect(instance);
    ClassMirror classMirror = mirror.type;

    sb.write(putIndent(0));
    sb.write("{");
    sb.write("\n");

    List<MethodMirror> getters = getAllGetters(classMirror);

    for(int i = 0; i < getters.length; i++){
      MethodMirror field = getters.elementAt(i);
      String fieldName = field.simpleName;
      sb.write(putIndent(indent + 1));
      sb.write("$fieldName: ");
      Object? fieldValue =  mirror.invokeGetter(fieldName);
      if(isPrimitive(fieldValue)){
        sb.write("$fieldValue");
      }
      else if(fieldValue is Map){
        sb.write("{\n");
        for (int j =0; j < fieldValue.entries.length; j++) {
          var item = fieldValue.entries.elementAt(j);
          sb.write(putIndent(indent + 2));
          sb.write("${item.key}:${item.value}");
          sb.write(",\n");
        }
        sb.write(putIndent(indent + 1));
        sb.write("}");
      }
      else if(fieldValue is List){
        sb.write("[");
        for(int j = 0; j < fieldValue.length; j++){
          var item = fieldValue.elementAt(j);
          if(isPrimitive(item)){
            sb.write("${fieldValue.elementAt(j)}");
          }
          else{
            sb.write(toJsonString(item,indent: indent));
          }
          if(j != fieldValue.length-1){
            sb.write(", ");
          }
        }
        sb.write("]");
      }
      else{
        sb.write(toJsonString(fieldValue!,indent: indent + 1));
      }
      if(i != getters.length -1){
        sb.write(",");
      }
      sb.write("\n");
    }
    sb.write(putIndent(indent));
    sb.write("}");
    return sb.toString();
  }

}