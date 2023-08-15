{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  cmake,
  extra-cmake-modules,
  gettext,
  fcitx5,
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-sayura";
  version = "5.0.8";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-WhRGpiD2nNfXXycowS3isL4Gg1BFcX75Xqby7oBxSos=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    gettext
  ];

  buildInputs = [
    fcitx5
  ];

  meta = with lib; {
    description = "Sayura support for Fcitx5";
    homepage = "https://github.com/fcitx/${pname}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [pluiedev];
    platforms = platforms.linux;
  };
}
