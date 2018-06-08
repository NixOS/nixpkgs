{ stdenv, fetchFcitxSource, cmake, fcitx, gettext, libchewing, pkgconfig }:

stdenv.mkDerivation rec {
  pname = "fcitx-chewing";
  version = "0.2.2";

  src = fetchFcitxSource {
    inherit pname version;
    sha256 = "0l548xdx2fvjya1ixp37pn382yak0m4kwfh9lgh7l3y2sblqw9zs";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake fcitx gettext libchewing ];

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
