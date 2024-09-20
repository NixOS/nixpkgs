{
  lib,
  mkKdeDerivation,
  fetchurl,
  libGLU,
  libGL,
  pkg-config,
  libpulseaudio,
  qt5compat,
  qttools,
}:
mkKdeDerivation rec {
  pname = "phonon";
  version = "4.12.0";

  src = fetchurl {
    url = "mirror://kde/stable/phonon/${version}/phonon-${version}.tar.xz";
    hash = "sha256-Mof/4PvMLUqhNj+eFXRzAtCwgAkP525fIR2AnstD85o=";
  };

  extraBuildInputs = [
    libGLU
    libGL
    libpulseaudio
    qt5compat
  ];

  extraNativeBuildInputs = [
    pkg-config
    qttools
  ];

  cmakeFlags = ["-DPHONON_BUILD_QT5=0" "-DPHONON_BUILD_QT6=1"];

  meta.license = with lib.licenses; [lgpl21Plus gpl2Plus];
  meta.mainProgram = "phononsettings";
}
