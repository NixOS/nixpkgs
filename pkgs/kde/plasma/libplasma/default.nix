{
  mkKdeDerivation,
  qtsvg,
  qttools,
  qtwayland,
  wayland,
  pkg-config,
}:
mkKdeDerivation {
  pname = "libplasma";

  extraNativeBuildInputs = [
    pkg-config
    (qttools.override { withClang = true; })
  ];

  extraBuildInputs = [
    qtsvg
    qtwayland
    wayland
  ];
}
