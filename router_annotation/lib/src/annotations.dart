enum FieldRename {
  none,
  kebab,
  snake,
  pascal,
}

enum PageTransitionType {
  rightToLeft,
  bottomToTop,
  fade,
}

class Page {
  const Page({
    required this.name,
    required this.routeName,
    this.fieldRename = FieldRename.snake,
    this.flavor,
    this.restoreable = false,
    this.transitionType = PageTransitionType.rightToLeft,
    this.fullscreenDialog = false,
    this.opaque = false,
    this.includeInManifest = true,
  });

  final String name;
  final String routeName;
  final FieldRename fieldRename;
  final String? flavor;
  final bool restoreable;
  final PageTransitionType transitionType;
  final bool fullscreenDialog;
  final bool opaque;
  final bool includeInManifest;
}

class Manifest {
  const Manifest();
}
