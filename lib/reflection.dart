import 'package:reflectable/reflectable.dart';


class ReflectableClass extends Reflectable {
  const ReflectableClass()
      : super(
    invokingCapability,
    declarationsCapability,
    typeCapability,
    typeRelationsCapability,
    reflectedTypeCapability,
    instanceInvokeCapability,
    superclassQuantifyCapability,
  );
}

const reflectable = ReflectableClass();