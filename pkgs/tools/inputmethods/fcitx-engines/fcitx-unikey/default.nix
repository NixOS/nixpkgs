{ stdenv, fetchurl, cmake, fcitx, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fcitx-unikey-${version}";
  version = "0.2.5";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-unikey/${name}.tar.xz";
    sha256 = "063vc29v7ycaai98v3z4q319sv9sm91my17pmhblw1vifxnw02wf";
  };

  buildInputs = [ cmake fcitx gettext pkgconfig ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace data/cmake_install.cmake \
      --replace ${fcitx} $out
  '';
  
  meta = with stdenv.lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-unikey";
    downloadPage  = "http://download.fcitx-im.org/fcitx-table-other/";
    description   = "Fcitx wrapper for unikey";
    license       = licenses.gpl3Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}