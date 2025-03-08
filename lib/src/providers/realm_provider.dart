import 'package:flutter/widgets.dart';
import 'package:realm/realm.dart';

class RealmProvider extends InheritedWidget {
  final Realm realm;

  const RealmProvider({
    Key? key,
    required this.realm,
    required Widget child,
  }) : super(key: key, child: child);

  static Realm of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<RealmProvider>();
    if (provider == null) {
      throw FlutterError('No RealmProvider found in context');
    }
    return provider.realm;
  }

  @override
  bool updateShouldNotify(RealmProvider oldWidget) => realm != oldWidget.realm;
}
