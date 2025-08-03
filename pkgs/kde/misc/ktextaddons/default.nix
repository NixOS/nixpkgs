{
  lib,
  mkKdeDerivation,
  fetchurl,
  fetchpatch,
  qtspeech,
  qttools,
  kxmlgui,
}:
mkKdeDerivation rec {
  pname = "ktextaddons";
  version = "1.7.0";

  src = fetchurl {
    url = "mirror://kde/stable/ktextaddons/ktextaddons-${version}.tar.xz";
    hash = "sha256-7JtimpC0shZgaGfoA08UszRDQgwreybz/UFNjB+jyuQ=";
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
