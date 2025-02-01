{ lib
, stdenv
, binutils
, cmake
, extra-cmake-modules
, patchelfUnstable
, wrapQtAppsHook
, elfutils
, fetchFromGitHub
, kconfigwidgets
, kddockwidgets
, ki18n
, kio
, kitemmodels
, kitemviews
, konsole
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
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "KDAB";
    repo = "hotspot";
    rev = "refs/tags/v${version}";
    hash = "sha256-O2wp19scyHIwIY2AzKmPmorGXDH249/OhSg+KtzOYhI=";
    fetchSubmodules = true;
  };

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
    konsole
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
    description = "GUI for Linux perf";
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
