import 'package:dictionary_app/helpers/state.dart';
import 'package:dictionary_app/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'views/home.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: App(),
    )
  ], child: App()));
}

class App extends StatelessWidget {
  const App({super.key});
  
  @override
  Widget build(BuildContext context) {
    final AppState appState = StateUtils.appStateWithContext(context);
    
    appState.appInit();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Home());
  }
}
