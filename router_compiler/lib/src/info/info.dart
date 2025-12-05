// ignore_for_file: deprecated_member_use

import 'package:analyzer/dart/element/element.dart';
import 'package:router_annotation/router_annotation.dart';

class PageInfo {
  const PageInfo({
    required this.uri,
    required this.displayName,
    required this.name,
    required this.routeName,
    required this.fieldRename,
    required this.constructor,
    required this.restoreable,
    this.flavor,
    this.transitionType = PageTransitionType.rightToLeft,
    this.fullscreenDialog = false,
    this.opaque = false,
  });

  final Uri uri;
  final String displayName;
  final String name;
  final String routeName;
  final FieldRename fieldRename;
  final ConstructorElement constructor;
  final String? flavor;
  final bool restoreable;
  final PageTransitionType transitionType;
  final bool fullscreenDialog;
  final bool opaque;

  String get controllerDisplayName => '${displayName}Controller';

  String get providerDisplayName => '${displayName}Provider';

  String convertField(String name) {
    switch (fieldRename) {
      case FieldRename.none:
        return name;
      case FieldRename.kebab:
        return _kebabCase(name);
      case FieldRename.snake:
        return _snakeCase(name);
      case FieldRename.pascal:
        return _pascalCase(name);
    }
  }

  String convertTransitionField() {
    return transitionType.name;
  }

  String _kebabCase(String input) => _fixCase(input, '-');

  String _snakeCase(String input) => _fixCase(input, '_');

  String _pascalCase(String input) {
    if (input.isEmpty) {
      return '';
    }
    return input[0].toUpperCase() + input.substring(1);
  }

  String _fixCase(String input, String separator) {
    return input.replaceAllMapped(RegExp('[A-Z]|[0-9]+'), (Match match) {
      String lower = match.group(0)!.toLowerCase();
      if (match.start > 0) {
        lower = '$separator$lower';
      }
      return lower;
    });
  }
}
