import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'store.g.dart';

AppStore get appStore => StoreBase.instance;

class AppStore = StoreBase with _$AppStore;

abstract class StoreBase with Store {
  static AppStore instance = AppStore();

  @observable int type = 20;
  @observable int errorLevel = 1;
  @observable int delay = 500;
  @observable int repair = 2;

  @action
  Future<void> save() async {
    final prefs = SharedPreferencesAsync();
    await prefs.setInt("type", type);
    await prefs.setInt("errorLevel", errorLevel);
    await prefs.setInt("delay", delay);
    await prefs.setInt("repair", delay);
  }

  @action
  Future<void> load() async {
    final prefs = SharedPreferencesAsync();
    type = await prefs.getInt("type") ?? 20;
    errorLevel = await prefs.getInt("errorLevel") ?? 1;
    delay = await prefs.getInt("delay") ?? 500;
    repair = await prefs.getInt("repair") ?? 2;
  }
}
