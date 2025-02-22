{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  fetchpatch,
  kcoreaddons,
  kdeclarative,
  kdecoration,
  libplasma,
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

  patches = [
    # Needed for the new kdecorations3 (part of plasma 6.3) and should no longer be needed with next release.
    (fetchpatch {
      url = "https://github.com/moodyhunter/applet-window-buttons6/commit/326382805641d340c9902689b549e4488682f553.patch";
      hash = "sha256-xlrmA/SSPH41VE7xjYJ8xQ1EVBnE8jMbwnuDSpKWQPM=";
    })
    (fetchpatch {
      url = "https://github.com/moodyhunter/applet-window-buttons6/commit/e27cd7559581e84b559a5da2c7bc6ea5a3f5bf15.patch";
      hash = "sha256-1GwZh2ZR9+cB+4ggiwsNN1KT5m8tsi/AEGZK0Cx5sdw=";
    })
  ];

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
