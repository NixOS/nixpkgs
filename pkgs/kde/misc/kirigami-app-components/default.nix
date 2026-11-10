{
  lib,
  mkKdeDerivation,
  fetchurl,
}:
mkKdeDerivation rec {
  pname = "kirigami-app-components";
  version = "1.1.1";

  src = fetchurl {
    url = "mirror://kde/stable/kirigami-app-components/kirigami-app-components-${version}.tar.xz";
    hash = "sha256-9o9NCCkzIT2CuAUhfy+gaQ9R330AIU3bhzgSpgprgws=";
  };

  meta.license = with lib.licenses; [
    bsd3
    cc0
    fsfap
    lgpl2Plus
    lgpl21Plus
  ];
}
