{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtdeclarative,
  qtmultimedia,
  qt5compat,
  qttools,
  kitemmodels,
}:
mkKdeDerivation rec {
  pname = "kirigami-addons";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://kde/stable/kirigami-addons/kirigami-addons-${version}.tar.xz";
    hash = "sha256-yY+Sv3xFLhL23EA0BCFUE9s5Wf6QStgw6tDba7CbPRE=";
  };

  extraNativeBuildInputs = [ qttools ];
  extraBuildInputs = [ qtdeclarative ];
  extraPropagatedBuildInputs = [
    qt5compat
    qtmultimedia
    kitemmodels
  ];

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
