{
  mkKdeDerivation,
  python3,
  libxml2,
  qtsvg,
  buildPackages,
  stdenv,
  lib,
}:
mkKdeDerivation {
  pname = "breeze-icons";

  extraNativeBuildInputs =
    [
      (python3.withPackages (ps: [ ps.lxml ]))
      libxml2
    ]
    ++ lib.optional (
      stdenv.system != buildPackages.stdenv.system
    ) buildPackages.kdePackages.breeze-icons.devtools;

  # This package contains an SVG icon theme and an API forcing its use
  extraPropagatedBuildInputs = [
    qtsvg
  ];

  # lots of icons, takes forever, does absolutely nothing
  dontStrip = true;

  postInstall = ''
    mkdir -p $devtools/bin
    install -m755 bin/generate-symbolic-dark $devtools/bin/generate-symbolic-dark
    install -m755 bin/qrcAlias $devtools/bin/qrcAlias
  '';

  # known upstream issue: https://invent.kde.org/frameworks/breeze-icons/-/commit/135e59fb4395c1779a52ab113cc70f7baa53fd5d
  dontCheckForBrokenSymlinks = true;
}
