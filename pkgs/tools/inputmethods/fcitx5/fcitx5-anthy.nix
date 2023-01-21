{ lib, stdenv, fetchurl, cmake, extra-cmake-modules, pkg-config, fcitx5, anthy, gettext }:

stdenv.mkDerivation rec {
  pname = "fcitx5-anthy";
  version = "5.0.13";

  src = fetchurl {
    url = "https://download.fcitx-im.org/fcitx5/fcitx5-anthy/${pname}-${version}.tar.xz";
    sha256 = "sha256-EGpyYiNalm4En3Oa++hyOSPLhjbkVcDyZt3LqamfSOI=";
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
