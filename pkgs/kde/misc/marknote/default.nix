{
  lib,
  mkKdeDerivation,
  fetchurl,
  kcrash,
  qtdeclarative,
  qtsvg,
  qtwayland,
  qqc2-desktop-style
}:
mkKdeDerivation rec {
  pname = "marknote";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://kde/stable/marknote/marknote-${version}.tar.xz";
    hash = "sha256-HzImkm8l8Rqiuyq2QezfdqJ1hxIdLZhiIGVM9xzpyaA=";
  };

  extraBuildInputs = [
    kcrash
    qtdeclarative
    qtsvg
    qtwayland
    qqc2-desktop-style
  ];

  meta.license = [ lib.licenses.gpl2Plus ];
}
