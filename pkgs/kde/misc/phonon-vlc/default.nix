{
  lib,
  mkKdeDerivation,
  fetchurl,
  qttools,
  libvlc,
}:
mkKdeDerivation rec {
  pname = "phonon-vlc";
  version = "0.12.0";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/phonon-backend-vlc/${version}/phonon-backend-vlc-${version}.tar.xz";
    hash = "sha256-M4R53EUeS5SzyltXje90Hc+C9cYmooB9NiNb4tznyaU=";
  };

  extraNativeBuildInputs = [qttools];
  extraBuildInputs = [libvlc];

  cmakeFlags = ["-DPHONON_BUILD_QT5=0" "-DPHONON_BUILD_QT6=1"];

  meta.license = with lib.licenses; [lgpl21Plus];
}
