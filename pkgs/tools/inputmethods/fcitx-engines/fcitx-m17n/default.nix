{ stdenv, fetchurl, cmake, fcitx, gettext, m17n_lib, m17n_db, pkgconfig }:

stdenv.mkDerivation rec {
  name = "fcitx-m17n-${version}";
  version = "0.2.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-m17n/${name}.tar.xz";
    sha256 = "0ffyhsg7bc6525k94kfhnja1h6ajlfprq72d286dp54cksnakyc4";
  };

  buildInputs = [ cmake fcitx gettext m17n_lib m17n_db pkgconfig ];

  preInstall = ''
    substituteInPlace im/cmake_install.cmake \
    --replace ${fcitx} $out
    '';

  meta = with stdenv.lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-m17n";
    downloadPage  = "http://download.fcitx-im.org/fcitx-table-other/";
    description   = "Fcitx wrapper for m17n";
    license       = licenses.gpl3Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
