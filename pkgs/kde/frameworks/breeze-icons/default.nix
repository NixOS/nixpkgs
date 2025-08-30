{
  mkKdeDerivation,
  python3,
  libxml2,
  qtsvg,
}:
mkKdeDerivation {
  pname = "breeze-icons";

  extraNativeBuildInputs = [
    (python3.withPackages (ps: [ ps.lxml ]))
    libxml2
  ];

  patches = [
    # https://bugs.kde.org/show_bug.cgi?id=508718
    # https://invent.kde.org/frameworks/breeze-icons/-/merge_requests/496
    ./reproducible-builds.patch
  ];

  # This package contains an SVG icon theme and an API forcing its use
  extraPropagatedBuildInputs = [
    qtsvg
  ];

  # lots of icons, takes forever, does absolutely nothing
  dontStrip = true;

  # known upstream issue: https://invent.kde.org/frameworks/breeze-icons/-/commit/135e59fb4395c1779a52ab113cc70f7baa53fd5d
  dontCheckForBrokenSymlinks = true;
}
