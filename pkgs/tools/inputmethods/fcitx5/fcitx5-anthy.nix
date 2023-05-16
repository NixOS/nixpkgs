{ lib, stdenv, fetchurl, cmake, extra-cmake-modules, pkg-config, fcitx5, anthy, gettext }:

stdenv.mkDerivation rec {
  pname = "fcitx5-anthy";
<<<<<<< HEAD
  version = "5.1.0";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/fcitx5-anthy/${pname}-${version}.tar.xz";
    sha256 = "sha256-tyWxNhCreJaAc+IUH85iayo8OALcY0ytFc7Aa8Ye80M=";
=======
  version = "5.0.14";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/fcitx5-anthy/${pname}-${version}.tar.xz";
    sha256 = "sha256-CodNcN9O8i8euGjCfq9m4zVOFgnbje05JUT49rxUp7c=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake extra-cmake-modules pkg-config ];
  buildInputs = [ fcitx5 anthy gettext ];

  meta = with lib; {
    description = "Anthy Wrapper for Fcitx5";
    homepage = "https://github.com/fcitx/fcitx5-anthy";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ elnudev ];
    platforms = platforms.linux;
  };
}
