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
, opencv
, xorg
, withOpencv ? true
, withX11 ? true
}:


stdenv.mkDerivation rec {
  pname = "ueberzugpp";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "jstkdng";
    repo = "ueberzugpp";
    rev = "v${version}";
    hash = "sha256-PTI+jIsXq4yh8TBAT1p1CLbBMDW1U323WgPoASz2pwA=";
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

  meta = with lib; {
    description = "Drop in replacement for ueberzug written in C++";
    homepage = "https://github.com/jstkdng/ueberzugpp";
    license = licenses.gpl3Plus;
    mainProgram = "ueberzug";
    maintainers = with maintainers; [ aleksana ];
    platforms = platforms.unix;
    broken = stdenv.isDarwin && stdenv.isx86_64;
  };
}
