{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtspeech,
  qttools,
  kxmlgui,
}:
mkKdeDerivation rec {
  pname = "ktextaddons";
  version = "2.2.0";

  src = fetchurl {
    url = "mirror://kde/stable/ktextaddons/ktextaddons-${version}.tar.xz";
    hash = "sha256-JrePq4LOdvoZ2NKkd1djHSHcrdtoFEQrbdKFPmXNWoE=";
  };

  extraBuildInputs = [
    qtspeech
    qttools
    kxmlgui
  ];

  meta.license = with lib.licenses; [
    bsd3
    cc0
    gpl2Plus
    lgpl2Plus
    lgpl21Plus
  ];
}
