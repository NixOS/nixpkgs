{
  lib,
  mkKdeDerivation,
  fetchurl,
  qtsvg,
  qtwebengine,
  kconfigwidgets,
  kitemmodels,
}:
mkKdeDerivation rec {
  pname = "klevernotes";
  version = "1.2.2";

  src = fetchurl {
    url = "mirror://kde/stable/klevernotes/${version}/klevernotes-${version}.tar.xz";
    hash = "sha256-WQoeozREN4GsqUC4OlYTrirt+fYa1yeT90RaJxvTH3I=";
  };

  extraBuildInputs = [
    qtsvg
    qtwebengine
    kconfigwidgets
    kitemmodels
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
