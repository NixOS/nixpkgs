{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtdeclarative,
  qtsvg,
  qtwayland,
}:
mkKdeDerivation rec {
  pname = "marknote";
  version = "1.4.1";

  src = fetchurl {
    url = "mirror://kde/stable/marknote/marknote-${version}.tar.xz";
    hash = "sha256-lsL1UcPZoJzbwtbMJC5ks6nIEd9/KUENW4WHHsKtJ5k=";
  };

  extraBuildInputs = [
    qtdeclarative
    qtsvg
    qtwayland
  ];

  meta.license = [ lib.licenses.gpl2Plus ];
}
