{ stdenv, fetchFcitxSource, cmake, pkgconfig, fcitx, gettext, curl }:

stdenv.mkDerivation rec {
  pname = "fcitx-cloudpinyin";
  version = "0.3.4";

  src = fetchFcitxSource {
    inherit pname version;
    sha256 = "143x9gbswzfngvgfy77zskrzrpywj8qg2d19kisgfwfisk7yhcf1";
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
