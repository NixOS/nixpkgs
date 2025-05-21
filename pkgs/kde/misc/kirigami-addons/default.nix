{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtdeclarative,
  qt5compat,
  qttools,
}:
mkKdeDerivation rec {
  pname = "kirigami-addons";
  version = "1.8.0";

  src = fetchurl {
    url = "mirror://kde/stable/kirigami-addons/kirigami-addons-${version}.tar.xz";
    hash = "sha256-USAIVeTyhVCfcbHPkjmjRQYx+Aj109CETroBAfW00es=";
  };

  extraNativeBuildInputs = [ (qttools.override { withClang = true; }) ];
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
