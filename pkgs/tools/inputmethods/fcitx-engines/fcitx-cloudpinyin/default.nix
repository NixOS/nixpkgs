{ stdenv, fetchurl, cmake, pkgconfig, fcitx, gettext, curl }:

stdenv.mkDerivation rec {
  name = "fcitx-cloudpinyin-${version}";
  version = "0.3.4";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-cloudpinyin/${name}.tar.xz";
    sha256 = "143x9gbswzfngvgfy77zskrzrpywj8qg2d19kisgfwfisk7yhcf1";
  };

  buildInputs = [ cmake pkgconfig fcitx gettext curl ];

  preInstall = ''
    substituteInPlace src/cmake_install.cmake \
      --replace ${fcitx} $out
    substituteInPlace po/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    description  = "A standalone module for fcitx that uses web API to provide better pinyin result";
    homepage     = https://github.com/fcitx/fcitx-cloudpinyin;
    license      = licenses.gpl3Plus;
    platforms    = platforms.linux;
  };
}
