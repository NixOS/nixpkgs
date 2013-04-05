{ stdenv, fetchurl, zlib, readline }:

let version = "9.2.4"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "14xfzw3hb2fn60c438v3j7wa65jjm2pnmx4qb4i4ji4am0cdjzfr";
  };

  buildInputs = [ zlib readline ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.1";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
