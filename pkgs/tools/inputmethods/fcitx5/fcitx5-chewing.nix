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
  version = "5.1.9";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-xl6jNC1tud121rnUFsphF0A739W16Vb9Qx4v1+vu99U=";
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

  meta = {
    description = "Chewing wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-chewing";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ xrelkd ];
    platforms = lib.platforms.linux;
  };
}
