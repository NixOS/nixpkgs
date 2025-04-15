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
  version = "1.5.4";

  src = fetchurl {
    url = "mirror://kde/stable/ktextaddons/ktextaddons-${version}.tar.xz";
    hash = "sha256-ZLgGAuhLJekWRiCvP2NB+oZbhegmq49eAgYa4koneyA=";
  };

  # Backport fix for Qt 6.9
  # FIXME: remove in next update
  patches = [
    (fetchpatch {
      url = "https://invent.kde.org/libraries/ktextaddons/-/commit/fdbb082aaa0125d60fdf819c9cb95c40bdb98800.patch";
      hash = "sha256-S+yGXXhZ/OdIgMGgyzofr1BzNV44/Uz/6NAoxdN9wRk=";
    })
  ];

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
