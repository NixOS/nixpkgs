{
  mkKdeDerivation,
  qtsvg,
  qtwayland,
  qtimageformats,
  phonon,
  phonon-vlc,
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
    qtsvg
    qtwayland
    # adds support for webp and other image formats
    qtimageformats

    phonon
    phonon-vlc

    cfitsio
    exiv2
    baloo
    kimageannotator
    lcms2
    libtiff
  ];
}
