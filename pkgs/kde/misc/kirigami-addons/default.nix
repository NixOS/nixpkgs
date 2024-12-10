{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtdeclarative,
  qt5compat,
}:
mkKdeDerivation rec {
  pname = "kirigami-addons";
  version = "1.2.1";

  src = fetchurl {
    url = "mirror://kde/stable/kirigami-addons/kirigami-addons-${version}.tar.xz";
    hash = "sha256-ZXQm+exVz+xafwSEjtK03yrIv8szwlYmrSOSGdRE7pg=";
  };

  extraBuildInputs = [ qtdeclarative ];
  extraPropagatedBuildInputs = [ qt5compat ];

  meta.license = with lib.licenses; [
    bsd2
    cc-by-sa-40
    cc0
    gpl2Plus
    lgpl2Only
    lgpl2Plus
    lgpl21Only
    lgpl21Plus
    lgpl3Only
  ];
}
