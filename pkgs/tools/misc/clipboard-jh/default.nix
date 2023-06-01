{ lib
, stdenv
, fetchFromGitHub
, cmake
, libffi
, pkg-config
, patchelf
, wayland-protocols
, wayland
, xorg
, darwin
}:

stdenv.mkDerivation rec {
  pname = "clipboard-jh";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Slackadays";
    repo = "clipboard";
    rev = version;
    hash = "sha256-RLb7R4BXnP7J5gX8hsE9yi6N3kezsutP1HqkmjR3yRs=";
  };

  postPatch = ''
    sed -i "/CMAKE_OSX_ARCHITECTURES/d" CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.isLinux [
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

  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/cb --add-rpath $out/lib
  '';

  meta = with lib; {
    description = "Cut, copy, and paste anything, anywhere, all from the terminal";
    homepage = "https://github.com/Slackadays/clipboard";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.all;
    mainProgram = "cb";
  };
}
