{ stdenv, fetchurl, zlib, readline }:

let version = "9.2.9"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "94ec6d330f125b6fc725741293073b07d7d20cc3e7b8ed127bc3d14ad2370197";
  };

  buildInputs = [ zlib readline ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  patches = [ ./disable-resolve_symlinks.patch ./less-is-more.patch ];

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
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
