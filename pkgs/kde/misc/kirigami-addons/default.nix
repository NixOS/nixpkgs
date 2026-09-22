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
  version = "1.14.0";

  src = fetchurl {
    url = "mirror://kde/stable/kirigami-addons/kirigami-addons-${version}.tar.xz";
    hash = "sha256-SunvnPH8Vf71kyjSWnCyhXK29qeHOUw9KS9e03jxmEA=";
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
