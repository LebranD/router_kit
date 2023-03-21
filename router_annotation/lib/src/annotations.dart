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
    this.transitionType = 'rightToLeft',
    this.fullscreenDialog,
    this.opaque,
    this.inheritTheme,
    this.isIos,
  });

  final String name;
  final String routeName;
  final FieldRename fieldRename;
  final String? flavor;
  final bool restoreable;
  final String transitionType;
  final bool? fullscreenDialog;
  final bool? opaque;
  final bool? inheritTheme;
  final bool? isIos;
}

class Manifest {
  const Manifest();
}
