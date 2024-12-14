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
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://kde/stable/marknote/marknote-${version}.tar.xz";
    hash = "sha256-/5lZhBWmzKWQDLTRDStypvOS6v4Hh0tuLrQun3qzvSg=";
  };

  extraBuildInputs = [
    qtdeclarative
    qtsvg
    qtwayland
  ];

  meta.license = [ lib.licenses.gpl2Plus ];
}
