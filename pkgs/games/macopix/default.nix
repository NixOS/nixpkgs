{ stdenv, fetchurl, pkgconfig, gtk, openssl }:

stdenv.mkDerivation rec {
  name = "macopix-1.7.4";

  src = fetchurl {
    url = "http://rosegray.sakura.ne.jp/macopix/${name}.tar.bz2";
    sha256 = "0sgnr0wrw3hglcnsyvipll7icfv69ssmyw584zfhk1rgramlkzyb";
  };

  buildInputs = [ pkgconfig gtk openssl ];

  meta = {
    description = "Mascot Constructive Pilot for X";
    homepage = http://rosegray.sakura.ne.jp/macopix/index-e.html;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
