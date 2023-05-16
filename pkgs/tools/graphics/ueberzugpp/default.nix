{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, cli11
, openssl
, zeromq
, cppzmq
, tbb_2021_8
, spdlog
, libsodium
, fmt
, vips
, nlohmann_json
, libsixel
<<<<<<< HEAD
, microsoft-gsl
, chafa
, enableOpencv ? stdenv.isLinux
, opencv
, enableWayland ? stdenv.isLinux
, extra-cmake-modules
, wayland
, wayland-protocols
, enableX11 ? stdenv.isLinux
, xorg
, withoutStdRanges ? stdenv.isDarwin
, range-v3
}:

stdenv.mkDerivation rec {
  pname = "ueberzugpp";
  version = "2.9.1";
=======
, opencv
, xorg
, withOpencv ? true
, withX11 ? true
}:


stdenv.mkDerivation rec {
  pname = "ueberzugpp";
  version = "2.8.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "jstkdng";
    repo = "ueberzugpp";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-zI+ctJHxjDbAKjCFDpNgpQ6m6pPffd7TV5gmfPP/yv4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
=======
    hash = "sha256-PTI+jIsXq4yh8TBAT1p1CLbBMDW1U323WgPoASz2pwA=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    cli11
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  buildInputs = [
    openssl
    zeromq
    cppzmq
    tbb_2021_8
    spdlog
    libsodium
    fmt
    vips
    nlohmann_json
    libsixel
<<<<<<< HEAD
    microsoft-gsl
    chafa
    cli11
  ] ++ lib.optionals enableOpencv [
    opencv
  ] ++ lib.optionals enableWayland [
    extra-cmake-modules
    wayland
    wayland-protocols
  ] ++ lib.optionals enableX11 [
    xorg.libX11
    xorg.xcbutilimage
  ] ++ lib.optionals withoutStdRanges [
    range-v3
  ];

  cmakeFlags = lib.optionals (!enableOpencv) [
    "-DENABLE_OPENCV=OFF"
  ] ++ lib.optionals enableWayland [
    "-DENABLE_WAYLAND=ON"
  ] ++ lib.optionals (!enableX11) [
    "-DENABLE_X11=OFF"
  ];

  # error: aligned deallocation function of type 'void (void *, std::align_val_t) noexcept' is only available on macOS 10.14 or newer
  preBuild = lib.optionalString (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11.0") ''
    export MACOSX_DEPLOYMENT_TARGET=10.14
  '';

=======
  ] ++ lib.optionals withOpencv [
    opencv
  ] ++ lib.optionals withX11 [
    xorg.libX11
    xorg.xcbutilimage
  ];

  cmakeFlags = lib.optionals (!withOpencv) [
    "-DENABLE_OPENCV=OFF"
  ] ++ lib.optionals (!withX11) [
    "-DENABLE_X11=OFF"
  ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  meta = with lib; {
    description = "Drop in replacement for ueberzug written in C++";
    homepage = "https://github.com/jstkdng/ueberzugpp";
    license = licenses.gpl3Plus;
<<<<<<< HEAD
    maintainers = with maintainers; [ aleksana wegank ];
    platforms = platforms.unix;
=======
    mainProgram = "ueberzug";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin && stdenv.isx86_64;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
