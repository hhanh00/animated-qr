import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'store.g.dart';

AppStore get appStore => StoreBase.instance;

class AppStore = StoreBase with _$AppStore;

abstract class StoreBase with Store {
  static AppStore instance = AppStore();

  @observable int type = 20;
  @observable int errorLevel = 1;

  @action
  Future<void> save() async {
    final prefs = SharedPreferencesAsync();
    await prefs.setInt("type", type);
    await prefs.setInt("errorLevel", errorLevel);
  }

  @action
  Future<void> load() async {
    final prefs = SharedPreferencesAsync();
    type = await prefs.getInt("type") ?? 20;
    errorLevel = await prefs.getInt("errorLevel") ?? 1;
  }
}
