{
  mkKdeDerivation,
  qtsvg,
  qtwayland,
  pkg-config,
  cfitsio,
  exiv2,
  baloo,
  kimageannotator,
  lcms2,
  libtiff,
  wayland,
  wayland-protocols,
}:
mkKdeDerivation {
  pname = "gwenview";

  extraNativeBuildInputs = [pkg-config];
  extraBuildInputs = [
    qtsvg
    qtwayland

    cfitsio
    exiv2
    baloo
    kimageannotator
    lcms2
    libtiff
    wayland
    wayland-protocols
  ];
}
