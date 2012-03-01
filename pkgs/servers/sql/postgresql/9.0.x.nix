{ stdenv, fetchurl, zlib, readline }:

let version = "9.0.7"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0cyqlr4c9jl4d786s0h8d45vkx6343f664ys2jamyncb3pbjdgns";
  };

  buildInputs = [ zlib readline ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.0";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
