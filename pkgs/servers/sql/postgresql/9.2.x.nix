{ stdenv, fetchurl, zlib, readline }:

let version = "9.2.6"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "4ba98053a66e5678af93dbc2956e8b04623f759e174f48940c41f4251cf0f886";
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
