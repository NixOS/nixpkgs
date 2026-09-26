{
  mkKdeDerivation,
  pkg-config,
  ddcutil,
  qtwayland,
  fetchpatch,
}:
mkKdeDerivation {
  pname = "powerdevil";

  patches = [
    # backport fix for spurious low battery notifications
    # FIXME: remove in 6.7.6
    (fetchpatch {
      url = "https://invent.kde.org/plasma/powerdevil/-/commit/54f8a4a848fa02d06fefc5543f35224eef73670c.diff";
      hash = "sha256-YWUyOhFRUwzi+ISM2+TGctNDSUYc851U/b5hKkTmWXY=";
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    ddcutil
    qtwayland
  ];
}
