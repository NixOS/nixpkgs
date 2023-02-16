{ lib
, mkDerivation
, cmake
, elfutils
, extra-cmake-modules
, fetchFromGitHub
, kconfigwidgets
, ki18n
, kio
, kitemmodels
, kitemviews
, kparts
, kwindowsystem
, libelf
, qtbase
, threadweaver
, qtx11extras
, zstd
, kddockwidgets
, rustc-demangle
}:

mkDerivation rec {
  pname = "hotspot";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "hotspot";
    rev = "refs/tags/v${version}";
    hash = "sha256-DW4R7+rnonmEMbCkNS7TGodw+3mEyHl6OlFK3kbG5HM=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];
  buildInputs = [
    (elfutils.override { enableDebuginfod = true; }) # perfparser needs to find debuginfod.h
    kconfigwidgets
    ki18n
    kio
    kitemmodels
    kitemviews
    kparts
    kwindowsystem
    libelf
    qtbase
    threadweaver
    qtx11extras
    zstd
    kddockwidgets
    rustc-demangle
  ];

  # hotspot checks for the presence of third party libraries'
  # git directory to give a nice warning when you forgot to clone
  # submodules; but Nix clones them and removes .git (for reproducibility).
  # So we need to fake their existence here.
  postPatch = ''
    mkdir -p 3rdparty/{perfparser,PrefixTickLabels}/.git
  '';

  meta = with lib; {
    description = "A GUI for Linux perf";
    longDescription = ''
      hotspot is a GUI replacement for `perf report`.
      It takes a perf.data file, parses and evaluates its contents and
      then displays the result in a graphical way.
    '';
    homepage = "https://github.com/KDAB/hotspot";
    changelog = "https://github.com/KDAB/hotspot/releases/tag/v${version}";
    license = with licenses; [ gpl2Only gpl3Only ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ nh2 ];
  };
}
