// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:dart_style/dart_style.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:router_compiler/src/info/info.dart';

class ManifestWriter {
  ManifestWriter(this.element, this.infoMap);

  final ClassElement element;
  final Map<String, PageInfo> infoMap;

  final StringBuffer _buffer = StringBuffer();

  void generate() {
    final List<PageInfo> infos = <PageInfo>[];
    infos.addAll(infoMap.values);
    infos.sort((PageInfo a, PageInfo b) {
      return a.routeName.compareTo(b.routeName);
    });

    _buffer.write('''
import 'package:flutter/cupertino.dart';
import 'package:router_annotation/router_annotation.dart';

${infos.map((PageInfo info) => 'import \'${info.uri}\';').join('\n')}

class AppManifest {
  const AppManifest._();

  static final List<dynamic> controllers = <dynamic>[
${infos.map((PageInfo info) => '${info.controllerDisplayName}(),').join('\n')}
  ];

  static PageRoute transitionRouteBuilder(RouteSettings settings, WidgetBuilder routeBuilder) {
    final Map<String, dynamic>? arguments = (settings.arguments as Map<String, dynamic>?);
    final bool fullscreenDialog = arguments?['fullscreenDialog'] ?? false;
    final bool opaque = arguments?['opaque'] ?? true;
    final String? transitionTypeStr = arguments?['transitionType'];
    final transitionType = PageTransitionType.values.firstWhere((e) => e.name == transitionTypeStr, orElse: () => PageTransitionType.rightToLeft);
    if (transitionType == PageTransitionType.rightToLeft) {
      return CupertinoPageRoute(
        builder: (context) {
          return routeBuilder(context);
        },
        settings: settings,
      );
    }
    return PageRouteBuilder(
      opaque: opaque,
      fullscreenDialog: fullscreenDialog,
      pageBuilder: (context, animation, secondaryAnimation) => routeBuilder(context),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return transitionType == PageTransitionType.bottomToTop
            ? SlideTransition(
                position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),
                child: child,
              )
            : FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              );
      },
      settings: settings,
    );
  }
}
''');
  }

  @override
  String toString() => DartFormatter(pageWidth: 150, languageVersion: Version(3, 0, 0)).format(_buffer.toString());
}
