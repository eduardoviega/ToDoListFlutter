import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'screens/item_list_view.dart';
import 'screens/settings/settings_controller.dart';
import 'screens/settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          restorationScopeId: 'app',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
          ],
          theme: ThemeData().copyWith(
            colorScheme:
                const ColorScheme.light().copyWith(primary: Colors.green.shade300),
            dialogTheme: const DialogTheme()
                .copyWith(surfaceTintColor: Colors.grey.shade700),
          ),
          darkTheme: ThemeData(
            colorScheme:
                const ColorScheme.dark().copyWith(primary: Colors.green.shade300),
            dialogTheme: const DialogTheme()
                .copyWith(surfaceTintColor: Colors.grey.shade700),
            checkboxTheme: const CheckboxThemeData().copyWith(checkColor: MaterialStateProperty.all(Colors.white)),
            primaryTextTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black))
          ),
          themeMode: settingsController.themeMode,
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  default:
                    return ItemListView();
                }
              },
            );
          },
        );
      },
    );
  }
}
