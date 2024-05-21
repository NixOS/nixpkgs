{ lib
, stdenv
, binutils
, cmake
, extra-cmake-modules
, patchelfUnstable
, wrapQtAppsHook
, elfutils
, fetchFromGitHub
, fetchpatch
, kconfigwidgets
, kddockwidgets
, ki18n
, kio
, kitemmodels
, kitemviews
, kparts
, kwindowsystem
, libelf
, linuxPackages
, qtbase
, qtsvg
, rustc-demangle
, syntax-highlighting
, threadweaver
, zstd
}:

stdenv.mkDerivation rec {
  pname = "hotspot";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "hotspot";
    rev = "refs/tags/v${version}";
    hash = "sha256-FJkDPWqNwoWg/15tvMnwke7PVtWVuqT0gtJBFQE0qZ4=";
    fetchSubmodules = true;
  };

  patches = [
    # Backport stuck UI bug fix
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://github.com/KDAB/hotspot/commit/7639dee8617dba9b88182c7ff4887e8d3714ac98.patch";
      hash = "sha256-aAo9uEy+MBztMhnC5jB08moZBeRCENU22R39pqSBXOY=";
    })
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    # stable patchelf corrupts the binary
    patchelfUnstable
    wrapQtAppsHook
  ];

  buildInputs = [
    (elfutils.override { enableDebuginfod = true; }) # perfparser needs to find debuginfod.h
    kconfigwidgets
    kddockwidgets
    ki18n
    kio
    kitemmodels
    kitemviews
    kparts
    kwindowsystem
    libelf
    qtbase
    qtsvg
    rustc-demangle
    syntax-highlighting
    threadweaver
    zstd
  ];

  qtWrapperArgs = [
    "--suffix PATH : ${lib.makeBinPath [ linuxPackages.perf binutils ]}"
  ];

  preFixup = ''
    patchelf \
      --add-rpath ${lib.makeLibraryPath [ rustc-demangle ]} \
      --add-needed librustc_demangle.so \
      $out/libexec/hotspot-perfparser
  '';

  meta = with lib; {
    description = "A GUI for Linux perf";
    mainProgram = "hotspot";
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
