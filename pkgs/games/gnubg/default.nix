{ stdenv, fetchurl, pkgconfig, glib, python, gtk2, readline }:

let version = "1.06.002"; in
stdenv.mkDerivation {
  name = "gnubg-"+version;

  src = fetchurl {
    url = "http://gnubg.org/media/sources/gnubg-release-${version}-sources.tar.gz";
    sha256 = "11xwhcli1h12k6rnhhyq4jphzrhfik7i8ah3k32pqw803460n6yf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ python glib gtk2 readline ];

  configureFlags = [ "--with-gtk" "--with--board3d" ];

  meta = with stdenv.lib;
    { description = "World class backgammon application";
      homepage = http://www.gnubg.org/;
      license = licenses.gpl3;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
