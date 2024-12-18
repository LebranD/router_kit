import 'package:example/app/app_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppState();
  }
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: AppRouter.instance.onGenerateRoute,
      onUnknownRoute: AppRouter.instance.onUnknownRoute,
      builder: (BuildContext context, Widget? child) {
        /// 禁用系统字体控制
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaleFactor: 1.0,
            boldText: false,
          ),
          child: child!,
        );
      },
      onGenerateTitle: (BuildContext context) {
        return 'RouterKit';
      },
      theme: ThemeData.light().copyWith(
        platform: TargetPlatform.iOS,
      ),
    );
  }
}
