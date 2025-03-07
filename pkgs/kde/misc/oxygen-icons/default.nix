{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "oxygen-icons";
  version = "6.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-icons/oxygen-icons-${version}.tar.xz";
    hash = "sha256-KOwYKHXcwV2SePRc7RECaqOSR28fRUhxueLINwCOV3Q=";
  };

  dontStrip = true;

  meta.license = [lib.licenses.lgpl3Plus];
}
