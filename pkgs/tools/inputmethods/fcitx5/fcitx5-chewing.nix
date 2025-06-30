{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  gettext,
  fcitx5,
  libchewing,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-chewing";
  version = "5.1.7";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-QL1rRMsaDP98as0zlmoDPoVnbqbKQFoUFSCX+j31JcM=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    libchewing
  ];

  meta = with lib; {
    description = "Chewing wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-chewing";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ xrelkd ];
    platforms = platforms.linux;
  };
}
