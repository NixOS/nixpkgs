{
  stdenv,
  sources,

  cmake,
  pkg-config,
  libsForQt5,
  wayland-scanner,

  plasma-wayland-protocols,
  wayland,
  wayland-protocols,
}:
# not mkKdeDerivation because this is Qt5 land
stdenv.mkDerivation rec {
  pname = "kwayland-integration";
  inherit (sources.${pname}) version;

  src = sources.${pname};

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.extra-cmake-modules
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtwayland

    libsForQt5.kwayland
    libsForQt5.kwindowsystem

    plasma-wayland-protocols
    wayland
    wayland-protocols
    wayland-scanner
  ];

  dontWrapQtApps = true;
}
