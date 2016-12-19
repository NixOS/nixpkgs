{ stdenv, fetchurl, cmake, fcitx, libhangul, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fcitx-hangul-${version}";
  version = "0.3.0";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-hangul/${name}.tar.xz";
    sha256 = "1jq78nczliw6pnhfac8hspffybrry6syk17y0wwcq05j3r3nd2lp";
  };

  buildInputs = [ cmake fcitx libhangul gettext pkgconfig ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-hangul";
    downloadPage  = "http://download.fcitx-im.org/fcitx-hangul/";
    description   = "Fcitx Wrapper for hangul";
    license       = licenses.gpl2;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };
}
