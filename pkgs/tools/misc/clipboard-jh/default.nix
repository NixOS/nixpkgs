{ lib
, stdenv
, fetchFromGitHub
, cmake
, libffi
, pkg-config
, wayland-protocols
, wayland
, xorg
}:

stdenv.mkDerivation rec {
  pname = "clipboard-jh";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "Slackadays";
    repo = "clipboard";
    rev = version;
    sha256 = "sha256-xdogl2WDuQXeLFuBY1u7PSpaoVI9HKScOdxHZ3+whIg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libffi
    wayland-protocols
    wayland
    xorg.libX11
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='MinSizeRel'"
    "-Wno-dev"
    "-DINSTALL_PREFIX=${placeholder "out"}"
  ];

  meta = with lib; {
    description = "Cut, copy, and paste anything, anywhere, all from the terminal";
    homepage = "https://github.com/Slackadays/clipboard";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "clipboard";
  };
}
