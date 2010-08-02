{ stdenv, fetchurl, zlib, ncurses, readline }:

let version = "8.4.4"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0zp35f0q84id3jz2nlwgp2qxplywh4lfg2p5i9nv2zszas6kjsz6";
  };

  buildInputs = [ zlib ncurses readline ];

  LC_ALL = "C";

  passthru = { inherit readline; };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
