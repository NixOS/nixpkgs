{ stdenv, fetchurl, zlib, readline }:

let version = "9.0.5"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";
  
  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "016mnwpcyla49qr3gglgpyjwnq1ljjbs3q0s8vlfmazfkj0fxn2n";
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
