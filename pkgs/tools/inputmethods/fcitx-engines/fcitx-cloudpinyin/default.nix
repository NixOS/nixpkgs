{ stdenv, fetchurl, cmake, pkgconfig, fcitx, gettext, curl }:

stdenv.mkDerivation rec {
  pname = "fcitx-cloudpinyin";
  version = "0.3.7";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-cloudpinyin/${pname}-${version}.tar.xz";
    sha256 = "0ai347wv3qdjzcbh0j9hdjpzwvh2kk57324xbxq37nzagrdgg5x0";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ cmake fcitx gettext curl ];

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
