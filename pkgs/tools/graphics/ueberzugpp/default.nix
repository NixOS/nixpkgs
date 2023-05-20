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
, microsoft_gsl
, opencv
, xorg
, withOpencv ? stdenv.isLinux
, withX11 ? stdenv.isLinux
}:

stdenv.mkDerivation rec {
  pname = "ueberzugpp";
  version = "2.8.3";

  src = fetchFromGitHub {
    owner = "jstkdng";
    repo = "ueberzugpp";
    rev = "v${version}";
    hash = "sha256-U6jw1VQmc/E/vXBCVvjBsmLjhVf0MFuK+FK8jnEEl1M=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    cli11
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
    microsoft_gsl
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

  # error: aligned deallocation function of type 'void (void *, std::align_val_t) noexcept' is only available on macOS 10.14 or newer
  preBuild = lib.optionalString (stdenv.isDarwin && lib.versionOlder stdenv.hostPlatform.darwinMinVersion "11.0") ''
    export MACOSX_DEPLOYMENT_TARGET=10.14
  '';

  meta = with lib; {
    description = "Drop in replacement for ueberzug written in C++";
    homepage = "https://github.com/jstkdng/ueberzugpp";
    license = licenses.gpl3Plus;
    mainProgram = "ueberzug";
    maintainers = with maintainers; [ aleksana wegank ];
    platforms = platforms.unix;
  };
}
