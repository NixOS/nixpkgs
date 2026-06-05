{
  mkKdeDerivation,
  pkg-config,
  qtsvg,
  qtmultimedia,
  wayland-protocols,
}:
mkKdeDerivation {
  pname = "kclock";

  extraNativeBuildInputs = [ pkg-config ];

  extraBuildInputs = [
    qtsvg
    qtmultimedia

    wayland-protocols
  ];
}
