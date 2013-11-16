{ stdenv, fetchurl, zlib, readline }:

let version = "9.2.5"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "22c1edfd6a404bb15fba655863e94f09a10716ded1910a8bc98ee85f413007a4";
  };

  buildInputs = [ zlib readline ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  patches = [ ./disable-resolve_symlinks.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.2";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
  };
}
