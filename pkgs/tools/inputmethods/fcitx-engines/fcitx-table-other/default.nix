{ stdenv, fetchurl, fetchpatch, cmake, fcitx, gettext }:

stdenv.mkDerivation rec {
  name = "fcitx-table-other-${version}";
  version = "0.2.3";

  src = fetchurl {
    url = "http://download.fcitx-im.org/fcitx-table-other/${name}.tar.xz";
    sha256 = "12fqbsjrpx5pndx2jf7fksrlp01a4yxz62h2vpxrbkpk73ljly4v";
  };

  buildInputs = [ cmake fcitx gettext ];

  patches = [
    (fetchpatch { url = https://sources.debian.net/data/main/f/fcitx-table-other/0.2.3-3/debian/patches/0001-table-other-fix-build.patch;
                  sha256 = "06n1df9szfgfjm5al8r1mvp4cib5h0cm601kwngl6k1vqyyjzg1j";
                })
  ];

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
