{ lib
, stdenv
, cmake
, libepoxy
, extra-cmake-modules
, fetchFromGitHub
, glfw3
, wayland
, xorg
}:

stdenv.mkDerivation rec {
  pname = "wlay";
  version = "ed316060ac3ac122c0d3d8918293e19dfe9a6c90";

  src = fetchFromGitHub {
    owner = "atx";
    repo = "wlay";
    rev = version;
    hash = "sha256-Lu+EyoDHiXK9QzD4jdwbllCOCl2aEU+uK6/KxC2AUGQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    libepoxy
    extra-cmake-modules
    glfw3
    wayland
    xorg.libX11
  ];

  buildPhase = ''
    cd $TMPDIR
    cmake $src
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp $TMPDIR/wlay $out/bin/wlay
    chmod 555 $out/bin/wlay
  '';

  meta = with lib; {
    homepage = "https://github.com/atx/wlay";
    description = "Graphical output management for Wayland";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}
