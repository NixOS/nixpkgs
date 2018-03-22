{ stdenv, fetchurl, pkgconfig, glib, python, gtk2, readline }:

let version = "1.06.001"; in
stdenv.mkDerivation {
  name = "gnubg-"+version;

  src = fetchurl {
    url = "http://gnubg.org/media/sources/gnubg-release-${version}-sources.tar.gz";
    sha256 = "0snz3j1bvr25ji7lg82bl2gm2s2x9lrpc7viw0hclgz0ql74cw7b";
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
