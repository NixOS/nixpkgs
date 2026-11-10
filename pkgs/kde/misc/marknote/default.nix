{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtdeclarative,
  qtsvg,
  qtwayland,
  kxmlgui,
}:
mkKdeDerivation rec {
  pname = "marknote";
  version = "1.6.0";

  src = fetchurl {
    url = "mirror://kde/stable/marknote/marknote-${version}.tar.xz";
    hash = "sha256-07s5YU4i/RqN3XS8+0w4TL/+JWhewBEW9pTkcIFihKk=";
  };

  extraBuildInputs = [
    qtdeclarative
    qtsvg
    qtwayland
    kxmlgui
  ];

  meta.license = lib.licenses.gpl2Plus;
}
