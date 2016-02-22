{ stdenv, fetchurl, cmake, fcitx, gettext, libchewing, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fcitx-chewing-${version}";
  version = "0.2.2";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-chewing/${name}.tar.xz";
    sha256 = "0l548xdx2fvjya1ixp37pn382yak0m4kwfh9lgh7l3y2sblqw9zs";
  };

  buildInputs = [ cmake fcitx gettext libchewing pkgconfig ];

  preInstall = ''
   substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
   substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-chewing";
    downloadPage  = "http://download.fcitx-im.org/fcitx-chewing/";
    description   = "Fcitx engine for chewing";
    license       = licenses.gpl2;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
