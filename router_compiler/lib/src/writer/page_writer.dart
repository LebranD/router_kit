import 'package:analyzer/dart/element/element.dart';
import 'package:router_annotation/router_annotation.dart';
import 'package:router_compiler/src/info/info.dart';
import 'package:router_compiler/src/util/utils.dart';

class PageWriter {
  PageWriter(this.info);

  final PageInfo info;

  final StringBuffer _buffer = StringBuffer();

  void generate({required bool withNullability}) {
    _generateController(withNullability: withNullability);
    _generateProvider(withNullability: withNullability);
  }

  void _generateController({required bool withNullability}) {
    // begin

    _buffer.writeln();

    _buffer.writeln('class ${info.controllerDisplayName} {');

    // blank
    _buffer.writeln();

    _buffer.writeln('String get name => ${info.providerDisplayName}.name;');

    // blank
    _buffer.writeln();

    _buffer.writeln('String get routeName => ${info.providerDisplayName}.routeName;');

    // blank
    _buffer.writeln();

    _buffer.writeln('WidgetBuilder get routeBuilder => ${info.providerDisplayName}.routeBuilder;');

    _buffer.writeln();

    _buffer.writeln('String? get flavor => ${info.providerDisplayName}.flavor;');

    // blank
    _buffer.writeln();
    _buffer
      ..writeln('@override')
      ..writeln('dynamic noSuchMethod(Invocation invocation) {')
      ..writeln('if (invocation.isGetter) {')
      ..writeln('switch (invocation.memberName) {')
      ..writeln('case #name:')
      ..writeln('return name;')
      ..writeln('case #routeName:')
      ..writeln('return routeName;')
      ..writeln('case #routeBuilder:')
      ..writeln('return routeBuilder;')
      ..writeln('case #flavor:')
      ..writeln('return flavor;')
      ..writeln('}')
      ..writeln('}')
      ..writeln('return super.noSuchMethod(invocation);')
      ..writeln('}');

    // end
    _buffer.writeln('}');
  }

  void _generateProvider({required bool withNullability}) {
    // begin
    _buffer.writeln('class ${info.providerDisplayName} {');

    // constructor
    _buffer.writeln('const ${info.providerDisplayName}._();');

    // blank
    _buffer.writeln();

    _buffer.writeln('static const String name = \'${info.name}\';');

    // blank
    _buffer.writeln();

    _buffer.writeln('static const String routeName = \'${info.routeName}\';');

    _buffer.writeln();

    _buffer.writeln('static const String? flavor = ${info.flavor != null ? '\'${info.flavor}\'' : null};');

    // blank
    _buffer.writeln();

    _buffer.writeln('static const PageTransitionType transitionType = \'${info.transitionType}\';');

    _buffer.writeln();

    _buffer.writeln('static const bool fullscreenDialog = ${info.fullscreenDialog};');

    _buffer.writeln();

    _buffer.writeln('static const bool opaque = ${info.opaque};');

    _buffer.writeln();

    //
    _buffer.writeln('static final WidgetBuilder routeBuilder = (BuildContext context) {');
    if (info.constructor.parameters.isNotEmpty) {
      _buffer.writeln(
          'Map<String, dynamic>${withNullability ? '?' : ''} arguments = ModalRoute.of(context)${withNullability ? '!' : ''}.settings.arguments as Map<String, dynamic>${withNullability ? '?' : ' ?? <String, dynamic>{}'};');
      final StringBuffer arguments = StringBuffer()
        ..writeln(<String>[
          if (info.constructor.parameters.any((ParameterElement element) => !element.isNamed))
            info.constructor.parameters
                .where((ParameterElement element) => !element.isNamed)
                .map((ParameterElement element) =>
                    'arguments${withNullability ? '?' : ''}[\'${info.convertField(element.name)}\'] as ${element.type.getDisplayString(withNullability: withNullability)},')
                .join('\n'),
          if (info.constructor.parameters.any((ParameterElement element) => element.isNamed))
            info.constructor.parameters
                .where((ParameterElement element) => element.isNamed)
                .map((ParameterElement element) =>
                    '${element.name}: arguments${withNullability ? '?' : ''}[\'${info.convertField(element.name)}\'] as ${element.type.getDisplayString(withNullability: withNullability)},')
                .join('\n'),
        ].join('\n'));
      _buffer.writeln('return ${info.displayName}($arguments);');
    } else {
      _buffer.writeln('return ${info.displayName}();');
    }
    _buffer.writeln('};');

    // 转场动画builder
    _buffer.writeln('static final WidgetBuilder transitionRouteBuilder = (BuildContext context, RouteSettings settings) {');
    if (info.constructor.parameters.isNotEmpty) {
      if (info.transitionType == PageTransitionType.bottomToTop) {
        _buffer.writeln('return PageRouteBuilder(');
        _buffer.writeln('opaque: opaque,');
        _buffer.writeln('fullscreenDialog: fullscreenDialog,');
        _buffer.writeln('pageBuilder: (context, animation, secondaryAnimation) => routeBuilder(context),');
        _buffer.writeln('transitionsBuilder: (context, animation, secondaryAnimation, child) {');
        _buffer.writeln('return SlideTransition(');
        _buffer.writeln('position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero).animate(animation),');
        _buffer.writeln('child: child,');
        _buffer.writeln(');');
        _buffer.writeln('},');
        _buffer.writeln('settings: settings,');
        _buffer.writeln(');');
        _buffer.writeln(');');
      } else if (info.transitionType == PageTransitionType.fade) {
        _buffer.writeln('return PageRouteBuilder(');
        _buffer.writeln('opaque: opaque,');
        _buffer.writeln('fullscreenDialog: fullscreenDialog,');
        _buffer.writeln('pageBuilder: (context, animation, secondaryAnimation) => routeBuilder(context),');
        _buffer.writeln('transitionsBuilder: (context, animation, secondaryAnimation, child) {');
        _buffer.writeln('return FadeTransition(');
        _buffer.writeln('opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),');
        _buffer.writeln('child: child,');
        _buffer.writeln(');');
        _buffer.writeln('},');
        _buffer.writeln('settings: settings,');
        _buffer.writeln(');');
        _buffer.writeln(');');
      } else {
        _buffer.writeln('return CupertinoPageRoute(');
        _buffer.writeln('builder: (context) {');
        _buffer.writeln('return routeBuilder(context);');
        _buffer.writeln('},');
        _buffer.writeln('settings: settings,');
        _buffer.writeln(');');
      }
    }
    _buffer.writeln('}');

    if (info.constructor.parameters.isNotEmpty) {
      // blank
      _buffer.writeln();

      _buffer
        ..writeln('static Map<String, dynamic> routeArgument(${<String>[
          if (info.constructor.parameters.any((ParameterElement element) => !element.isNamed && !element.isOptional))
            info.constructor.parameters
                .where((ParameterElement element) => !element.isNamed && !element.isOptional)
                .map((ParameterElement element) => '${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}')
                .join(', '),
          if (info.constructor.parameters.any((ParameterElement element) => !element.isNamed && element.isOptional))
            '[${info.constructor.parameters.where((ParameterElement element) => !element.isNamed && element.isOptional).map((ParameterElement element) => '${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},]',
          if (info.constructor.parameters.any((ParameterElement element) => element.isNamed))
            '{${info.constructor.parameters.where((ParameterElement element) => element.isNamed).map((ParameterElement element) => '${withNullability && element.isRequiredNamed ? 'required ' : ''}${!withNullability && element.hasRequired ? '@required ' : ''}${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},}',
        ].join(', ')}) {')
        ..writeln(
            'return <String, dynamic>{${info.constructor.parameters.map((ParameterElement element) => '\'${info.convertField(element.name)}\': ${element.name},').join('\n')}};')
        ..writeln('}');
    }

    // blank
    _buffer.writeln('');
    _buffer
      ..writeln('static Future<T${withNullability ? '?' : ''}> pushByNamed<T extends Object${withNullability ? '?' : ''}>(${<String>[
        'BuildContext context',
        if (info.constructor.parameters.any((ParameterElement element) => !element.isNamed && !element.isOptional))
          info.constructor.parameters
              .where((ParameterElement element) => !element.isNamed && !element.isOptional)
              .map((ParameterElement element) => '${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}')
              .join(', '),
        if (info.constructor.parameters.any((ParameterElement element) => !element.isNamed && element.isOptional))
          '[${info.constructor.parameters.where((ParameterElement element) => !element.isNamed && element.isOptional).map((ParameterElement element) => '${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},]',
        if (info.constructor.parameters.any((ParameterElement element) => element.isNamed))
          '{${info.constructor.parameters.where((ParameterElement element) => element.isNamed).map((ParameterElement element) => '${withNullability && element.isRequiredNamed ? 'required ' : ''}${!withNullability && element.hasRequired ? '@required ' : ''}${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},}',
      ].join(', ')}) {')
      ..writeAll(<String>[
        if (info.constructor.parameters.isNotEmpty) ...<String>[
          'return Navigator.of(context).pushNamed(routeName, arguments: <String, dynamic>{\'transitionType\':transitionType,\'fullscreenDialog\':fullscreenDialog,\'opaque\':opaque,\'inheritTheme\':inheritTheme,\'isIos\':isIos,${info.constructor.parameters.map((ParameterElement element) => '\'${info.convertField(element.name)}\': ${element.name},').join('\n')}},);',
        ],
        if (info.constructor.parameters.isEmpty) ...<String>[
          'return Navigator.of(context).pushNamed(routeName);',
        ],
      ], '\n')
      ..writeln('}');

    _buffer.writeln();

    if (info.restoreable) {
      _buffer
        ..writeln('static String restorePushByNamed<T extends Object${withNullability ? '?' : ''}>(${<String>[
          'BuildContext context',
          if (info.constructor.parameters.any((ParameterElement element) => !element.isNamed && !element.isOptional))
            info.constructor.parameters
                .where((ParameterElement element) => !element.isNamed && !element.isOptional)
                .map((ParameterElement element) => '${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}')
                .join(', '),
          if (info.constructor.parameters.any((ParameterElement element) => !element.isNamed && element.isOptional))
            '[${info.constructor.parameters.where((ParameterElement element) => !element.isNamed && element.isOptional).map((ParameterElement element) => '${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},]',
          if (info.constructor.parameters.any((ParameterElement element) => element.isNamed))
            '{${info.constructor.parameters.where((ParameterElement element) => element.isNamed).map((ParameterElement element) => '${withNullability && element.isRequiredNamed ? 'required ' : ''}${!withNullability && element.hasRequired ? '@required ' : ''}${formatPrettyDisplay(element.type, withNullability: withNullability)} ${element.name}${element.hasDefaultValue ? ' = ${element.defaultValueCode}' : ''}').join(', ')},}',
        ].join(', ')}) {')
        ..writeAll(<String>[
          if (info.constructor.parameters.isNotEmpty) ...<String>[
            'return Navigator.of(context).restorablePushNamed<T>(routeName, arguments: <String, dynamic>{${info.constructor.parameters.map((ParameterElement element) => '\'${info.convertField(element.name)}\': ${element.name},').join('\n')}},);'
          ],
          if (info.constructor.parameters.isEmpty) ...<String>[
            'return Navigator.of(context).restorablePushNamed<T>(routeName);',
          ],
        ], '\n')
        ..writeln('}');
    }

    // end
    _buffer.writeln('}');
  }

  @override
  String toString() => _buffer.toString();
}
