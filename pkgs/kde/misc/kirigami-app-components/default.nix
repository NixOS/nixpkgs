{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "kirigami-app-components";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://kde/stable/kirigami-app-components/kirigami-app-components-${version}.tar.xz";
    hash = "sha256-+D+S7Pq4n6i3WGfEfCkfFhnho5cK/DBDezN0qnX2Uw8=";
  };

  meta.license = with lib.licenses; [
    bsd3
    cc0
    fsfap
    lgpl2Plus
    lgpl21Plus
  ];
}
