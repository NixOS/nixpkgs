{ stdenv, fetchurl, cmake, fcitx, anthy }:

stdenv.mkDerivation rec {
  name = "fcitx-anthy-0.2.1";

  meta = with stdenv.lib; {
    description = "Fcitx Wrapper for anthy";
    license     = licenses.gpl2Plus;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ iyzsong ];
  };

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-anthy/${name}.tar.xz";
    sha256 = "13fpfhhxkzbq53h10i3hifa37nngm47jq361i70z22bgcrs8887x";
  };

  buildInputs = [ cmake fcitx anthy ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
  '';
}
