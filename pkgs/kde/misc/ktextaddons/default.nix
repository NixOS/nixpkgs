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
  version = "2.1.1";

  src = fetchurl {
    url = "mirror://kde/stable/ktextaddons/ktextaddons-${version}.tar.xz";
    hash = "sha256-fOWWG3qCrVDk/ytDhtdkzSnTCGAOu7X9duJJLTHg9fA=";
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
