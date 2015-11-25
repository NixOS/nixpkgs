{ stdenv, fetchurl, cmake, fcitx, gettext }:

stdenv.mkDerivation rec {
  name = "fcitx-table-other-${version}";
  version = "0.2.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-table-other/${name}.tar.xz";
    sha256 = "12fqbsjrpx5pndx2jf7fksrlp01a4yxz62h2vpxrbkpk73ljly4v";
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
