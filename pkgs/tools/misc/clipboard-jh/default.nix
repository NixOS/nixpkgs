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
<<<<<<< HEAD
, nix-update-script
, alsa-lib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "clipboard-jh";
<<<<<<< HEAD
  version = "0.8.1";
=======
  version = "0.7.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "Slackadays";
    repo = "clipboard";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-UlN2BjtzS54oImAGM2Kl+j/LwfAyDXtbEMhsijBh/yg=";
=======
    hash = "sha256-+1GgIa0kIOliI0ACiU9zQe24R6488xWEZ7n9nuxv3dY";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    alsa-lib
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='MinSizeRel'"
    "-Wno-dev"
    "-DINSTALL_PREFIX=${placeholder "out"}"
  ];

<<<<<<< HEAD
  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf $out/bin/cb --add-rpath $out/lib
  '';

  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Cut, copy, and paste anything, anywhere, all from the terminal";
    homepage = "https://github.com/Slackadays/clipboard";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    platforms = platforms.all;
    mainProgram = "cb";
  };
}
