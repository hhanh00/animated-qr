// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AppStore on StoreBase, Store {
  late final _$typeAtom = Atom(name: 'StoreBase.type', context: context);

  @override
  int get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(int value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$ecLevelAtom = Atom(name: 'StoreBase.ecLevel', context: context);

  @override
  int get ecLevel {
    _$ecLevelAtom.reportRead();
    return super.ecLevel;
  }

  @override
  set ecLevel(int value) {
    _$ecLevelAtom.reportWrite(value, super.ecLevel, () {
      super.ecLevel = value;
    });
  }

  late final _$delayAtom = Atom(name: 'StoreBase.delay', context: context);

  @override
  int get delay {
    _$delayAtom.reportRead();
    return super.delay;
  }

  @override
  set delay(int value) {
    _$delayAtom.reportWrite(value, super.delay, () {
      super.delay = value;
    });
  }

  late final _$repairAtom = Atom(name: 'StoreBase.repair', context: context);

  @override
  int get repair {
    _$repairAtom.reportRead();
    return super.repair;
  }

  @override
  set repair(int value) {
    _$repairAtom.reportWrite(value, super.repair, () {
      super.repair = value;
    });
  }

  late final _$saveAsyncAction = AsyncAction(
    'StoreBase.save',
    context: context,
  );

  @override
  Future<void> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$loadAsyncAction = AsyncAction(
    'StoreBase.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  @override
  String toString() {
    return '''
type: ${type},
ecLevel: ${ecLevel},
delay: ${delay},
repair: ${repair}
    ''';
  }
}
