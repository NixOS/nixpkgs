{ stdenv
, lib
, fetchFromGitHub
, unstableGitUpdater
, pkg-config
, libjack2
}:

stdenv.mkDerivation {
  pname = "jack-link";
  version = "unstable-2023-05-31";

  src = fetchFromGitHub {
    owner = "rncbc";
    repo = "jack_link";
    rev = "b97b349033075d8d4e681c252d1e7c59108d45c0";
    sha256 = "sha256-Jdahbv/VfGdOPRttBEoFxglzsqSCrv3fO8CY82WcugY=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libjack2
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    homepage = "https://github.com/rncbc/jack_link";
    description = "jack_link bridges JACK transport with Ableton Link.";
    license = licenses.gpl2Plus;
    mainProgram = "jack_link";
    maintainers = with maintainers; [ PowerUser64 ];
    platforms = platforms.linux;
  };
}
