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

  # This package contains an SVG icon theme and an API forcing its use
  extraPropagatedBuildInputs = [
    qtsvg
  ];

  # lots of icons, takes forever, does absolutely nothing
  dontStrip = true;
}
