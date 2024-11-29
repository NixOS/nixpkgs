{
  lib,
  mkKdeDerivation,
  fetchFromGitLab,
  qttools,
  libvlc,
}:
mkKdeDerivation rec {
  pname = "phonon-vlc";
  version = "0.12.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "libraries";
    repo = "phonon-vlc";
    rev = "v${version}";
    hash = "sha256-voaPjz+rrJfNoFYYytS0PgwpJN7Ui19LxWxDSOpMbko=";
  };

  extraNativeBuildInputs = [ qttools ];
  extraBuildInputs = [ libvlc ];

  cmakeFlags = [
    "-DPHONON_BUILD_QT5=0"
    "-DPHONON_BUILD_QT6=1"
  ];

  meta.license = with lib.licenses; [ lgpl21Plus ];
}
