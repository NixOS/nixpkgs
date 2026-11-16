{
  lib,
  mkKdeDerivation,
  fetchurl,

  oath-toolkit,
  qgpgme,
}:
mkKdeDerivation rec {
  pname = "plasma-pass";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://kde/stable/plasma-pass/plasma-pass-${version}.tar.xz";
    hash = "sha256-WoiYXcUiyjKH8T7ZiWCak4cZltToxbCkFZTi06L+jyo=";
  };

  extraBuildInputs = [
    oath-toolkit
    qgpgme
  ];

  meta.license = lib.licenses.lgpl21Plus;
}
