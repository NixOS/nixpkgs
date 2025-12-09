{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  kcmutils,
  kcoreaddons,
  kdeclarative,
  kdecoration,
  libplasma,
}:

stdenv.mkDerivation rec {
  pname = "applet-window-buttons6";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "moodyhunter";
    repo = "applet-window-buttons6";
    rev = "v${version}";
    hash = "sha256-HnlgBQKT99vVkl6DWqMkN8Vz+QzzZBGj5tqOJ22VkJ8=";
  };

  dontWrapQtApps = true;

  # kdecoration headers include C++20 spaceship operator
  env.NIX_CFLAGS_COMPILE = "-std=c++20";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kcmutils
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
