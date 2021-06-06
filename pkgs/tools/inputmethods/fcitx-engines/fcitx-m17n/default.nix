{ lib, stdenv, fetchurl, cmake, fcitx, gettext, m17n_lib, m17n_db, pkg-config }:

stdenv.mkDerivation rec {
  pname = "fcitx-m17n";
  version = "0.2.4";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-m17n/${pname}-${version}.tar.xz";
    sha256 = "15s52h979xz967f8lm0r0qkplig2w3wjck1ymndbg9kvj25ib0ng";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ fcitx gettext m17n_lib m17n_db ];

  preInstall = ''
    substituteInPlace im/cmake_install.cmake \
    --replace ${fcitx} $out
    '';

  meta = with lib; {
    isFcitxEngine = true;
    homepage      = "https://github.com/fcitx/fcitx-m17n";
    downloadPage  = "http://download.fcitx-im.org/fcitx-table-other/";
    description   = "Fcitx wrapper for m17n";
    license       = licenses.gpl3Plus;
    platforms     = platforms.linux;
    maintainers   = with maintainers; [ ericsagnes ];
  };

}
