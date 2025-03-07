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
  version = "1.5.4";

  src = fetchurl {
    url = "mirror://kde/stable/ktextaddons/ktextaddons-${version}.tar.xz";
    hash = "sha256-ZLgGAuhLJekWRiCvP2NB+oZbhegmq49eAgYa4koneyA=";
  };

  extraBuildInputs = [qtspeech qttools kxmlgui];

  meta.license = with lib.licenses; [
    bsd3
    cc0
    gpl2Plus
    lgpl2Plus
    lgpl21Plus
  ];
}
