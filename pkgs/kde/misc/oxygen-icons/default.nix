{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "oxygen-icons";
  version = "6.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/oxygen-icons/oxygen-icons-${version}.tar.xz";
    hash = "sha256-Yf0u9W56+7urA0BSAXJkrQDQdMe+BvCFXUyAWly6z90=";
  };

  dontStrip = true;

  meta.license = [ lib.licenses.lgpl3Plus ];
}
