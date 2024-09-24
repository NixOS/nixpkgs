{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtsvg,
  qtwebengine,
}:
mkKdeDerivation rec {
  pname = "klevernotes";
  version = "1.0.0";

  src = fetchurl {
    url = "mirror://kde/stable/klevernotes/${version}/klevernotes-${version}.tar.xz";
    hash = "sha256-9nXOaa2/DyJO3nXGbnvPaYjXFrVoAgx52th67l5geOU=";
  };

  extraBuildInputs = [
    qtsvg
    qtwebengine
  ];

  meta.license = with lib.licenses; [
    bsd3
    cc-by-sa-40
    cc0
    # TODO: add FSFAP license
    gpl2Plus
    gpl3Only
    gpl3Plus
    lgpl2Only
    lgpl2Plus
    lgpl21Only
    lgpl21Plus
    lgpl3Only
    lgpl3Plus
    mit
  ];
}
