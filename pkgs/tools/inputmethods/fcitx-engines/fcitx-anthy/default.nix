{ stdenv, fetchurl, cmake, fcitx, anthy, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fcitx-anthy-${version}";
  version = "0.2.2";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-anthy/${name}.tar.xz";
    sha256 = "0ayrzfx95670k86y19bzl6i6w98haaln3x8dxpb39a5dwgz59pf8";
  };

  buildInputs = [ cmake fcitx anthy gettext pkgconfig ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    description   = "Fcitx Wrapper for anthy";
    license       = licenses.gpl2Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
