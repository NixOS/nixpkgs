{
  mkKdeDerivation,
  qtmultimedia,
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
}:
mkKdeDerivation {
  pname = "gwenview";

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtmultimedia
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
  ];
}
