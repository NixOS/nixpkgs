{ stdenv, fetchurl, cmake, fcitx, anthy, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fcitx-anthy-${version}";
  version = "0.2.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-anthy/${name}.tar.xz";
    sha256 = "01jx7wwq0mifqrzkswfglqhwkszbfcl4jinxgdgqx9kc6mb4k6zd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake fcitx anthy gettext ];

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
