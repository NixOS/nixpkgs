{ lib
, stdenv
, fetchFromGitHub
, cmake
, libffi
, pkg-config
, wayland-protocols
, wayland
, xorg
, darwin
}:

stdenv.mkDerivation rec {
  pname = "clipboard-jh";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "Slackadays";
    repo = "clipboard";
    rev = version;
    hash = "sha256-o3yCWAy7hlFKAFW3tVRG+hL0SRWlNY4hvnhUoDK8GkI=";
  };

  postPatch = ''
    sed -i "/CMAKE_OSX_ARCHITECTURES/d" CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libffi
    wayland-protocols
    wayland
    xorg.libX11
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
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
