import 'package:dictionary_app/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class StateUtils {
  static AppState appStateWithContext(BuildContext context) =>
      Provider.of<AppState>(context, listen: false);

  static AppState appStateWithContextAndWithListener(BuildContext context) =>
    Provider.of<AppState>(context, listen: true);

}
