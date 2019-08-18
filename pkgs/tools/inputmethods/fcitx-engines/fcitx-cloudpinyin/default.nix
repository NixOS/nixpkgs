{ stdenv, fetchurl, cmake, pkgconfig, fcitx, gettext, curl }:

stdenv.mkDerivation rec {
  pname = "fcitx-cloudpinyin";
  version = "0.3.6";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-cloudpinyin/${pname}-${version}.tar.xz";
    sha256 = "1f3ryx817bxb8g942l50ng4xg0gp50rb7pv2p6zf98r2z804dcvf";
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
