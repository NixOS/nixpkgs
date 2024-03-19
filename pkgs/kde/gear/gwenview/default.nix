{
  mkKdeDerivation,
  qtsvg,
  qtwayland,
  qtimageformats,
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
    # adds support for webp and other image formats
    qtimageformats

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
