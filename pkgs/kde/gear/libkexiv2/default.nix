{
  mkKdeDerivation,
  qt5compat,
  pkg-config,
  exiv2,
  lib,
}:
mkKdeDerivation {
  pname = "libkexiv2";

  extraBuildInputs = [
    qt5compat
    exiv2
  ];
  extraNativeBuildInputs = [ pkg-config ];

  meta.platforms = lib.platforms.unix;
}
