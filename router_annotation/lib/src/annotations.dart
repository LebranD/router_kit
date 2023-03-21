import 'package:page_transition/page_transition.dart';

enum FieldRename {
  none,
  kebab,
  snake,
  pascal,
}

class Page {
  const Page({
    required this.name,
    required this.routeName,
    this.fieldRename = FieldRename.snake,
    this.flavor,
    this.restoreable = false,
    this.transitionType = PageTransitionType.rightToLeft,
  });

  final String name;
  final String routeName;
  final FieldRename fieldRename;
  final String? flavor;
  final bool restoreable;
  final PageTransitionType transitionType;
}

class Manifest {
  const Manifest();
}
