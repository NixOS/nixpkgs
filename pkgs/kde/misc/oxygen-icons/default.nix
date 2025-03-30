{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "oxygen-icons";
  version = "6.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-icons/oxygen-icons-${version}.tar.xz";
    hash = "sha256-FsqXEHnFBnxFB8q/G2GdyH3Wsyb9XC3Z9dQ4EPIXTWg=";
  };

  dontStrip = true;

  meta.license = [ lib.licenses.lgpl3Plus ];
}
