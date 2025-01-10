{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, extra-cmake-modules
, kcoreaddons
, kdeclarative
, kdecoration
, libplasma
}:

stdenv.mkDerivation rec {
  pname = "applet-window-buttons6";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "moodyhunter";
    repo = "applet-window-buttons6";
    rev = "v${version}";
    hash = "sha256-S7JcDPo4QDqi/RtvreFNoPKwTg14bgaFGsuGSDxs5nM=";
  };

  dontWrapQtApps = true;

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcoreaddons
    kdeclarative
    kdecoration
    libplasma
  ];

  meta = with lib; {
    description = "Plasma 6 applet in order to show window buttons in your panels";
    homepage = "https://github.com/moodyhunter/applet-window-buttons6";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ A1ca7raz ];
  };
}
