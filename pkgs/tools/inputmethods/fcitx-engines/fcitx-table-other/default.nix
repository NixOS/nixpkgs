{ stdenv, fetchurl, cmake, fcitx, gettext }:

stdenv.mkDerivation rec {
  pname = "fcitx-table-other";
  version = "0.2.4";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-table-other/${pname}-${version}.tar.xz";
    sha256 = "1di60lr6l5k2sdwi3yrc0hl89j2k0yipayrsn803vd040w1fgfhq";
  };

  buildInputs = [ cmake fcitx gettext ];

  preInstall = ''
   substituteInPlace tables/cmake_install.cmake \
      --replace ${fcitx} $out
  '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-table-other";
    downloadPage  = "http://download.fcitx-im.org/fcitx-table-other/";
    description   = "Provides some other tables for Fcitx";
    license       = licenses.gpl3Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
