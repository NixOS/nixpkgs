{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  extra-cmake-modules,
  gettext,
  fcitx5,
  libhangul,
  nixosTests,
}:

stdenv.mkDerivation rec {
  pname = "fcitx5-hangul";
  version = "5.1.8";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    hash = "sha256-6aBn0muWbmdxqUCrrXDRd4MZP7QUMX1ZHcAUdTF9Kys=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    gettext
  ];

  buildInputs = [
    fcitx5
    libhangul
  ];

  passthru.tests = {
    inherit (nixosTests) fcitx5;
  };

  meta = {
    description = "Hangul wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-hangul";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ xrelkd ];
    platforms = lib.platforms.linux;
  };
}
