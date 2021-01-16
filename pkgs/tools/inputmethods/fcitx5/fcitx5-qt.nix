{ lib, stdenv
, mkDerivation
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, qtx11extras
, libxcb
, libXdmcp
}:

mkDerivation rec {
  pname = "fcitx5-qt";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = "fcitx5-qt";
    rev = version;
    sha256 = "sha256-QylvjhjiIujYGKFtL4bKVXpobkN5t6Q2MGf16dsL24A=";
  };

  cmakeFlags = [
    "-DENABLE_QT4=0"
  ];

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    fcitx5
    qtx11extras
    libxcb
    libXdmcp
  ];

  meta = with lib; {
    description = "Fcitx5 Qt Library";
    homepage = "https://github.com/fcitx/fcitx5-qt";
    license = with licenses; [ lgpl21Plus bsd3 ];
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
