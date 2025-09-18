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
  version = "1.2.3";

  src = fetchurl {
    url = "mirror://kde/stable/klevernotes/${version}/klevernotes-${version}.tar.xz";
    hash = "sha256-eWCjZrOfjqu6uC9WDqwoYg9Vyss8PGxEXKzR+MgEg24=";
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
