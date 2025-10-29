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
  version = "1.2.4";

  src = fetchurl {
    url = "mirror://kde/stable/klevernotes/${version}/klevernotes-${version}.tar.xz";
    hash = "sha256-btnCn9YhA0aIhg6PXYuxsZQa6JeHyIrYwSKvTuqrsj8=";
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
