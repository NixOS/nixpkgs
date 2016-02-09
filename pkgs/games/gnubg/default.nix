{ stdenv, fetchurl, pkgconfig, glib, python, gtk2 }:

let version = "1.04.000"; in
stdenv.mkDerivation {
  name = "gnubg-"+version;

  src = fetchurl {
    url = "http://gnubg.org/media/sources/gnubg-release-${version}-sources.tar.gz";
    sha256 = "0gsfl6qbj529d1jg3bkyj9m7bvb566wd7pq5fslgg5yn6c6rbjk6";
  };

  buildInputs = [ pkgconfig python glib gtk2 ];

  configureFlags = [ "--with-gtk" "--with--board3d" ];

  meta = with stdenv.lib;
    { description = "World class backgammon application";
      homepage = http://www.gnubg.org/;
      license = licenses.gpl3;
      maintainers = [ maintainers.ehmry ];
      platforms = platforms.linux;
    };
}
