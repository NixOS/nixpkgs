{
  mkKdeDerivation,
  qt5compat,
  pkg-config,
  exiv2,
}:
mkKdeDerivation {
  pname = "libkexiv2";

  extraBuildInputs = [
    qt5compat
    exiv2
  ];
  extraNativeBuildInputs = [ pkg-config ];
}
