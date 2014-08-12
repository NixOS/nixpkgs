{ stdenv, fetchurl, zlib, readline, libossp_uuid }:

with stdenv.lib;

let version = "9.3.5"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "14176ffb1f90a189e7626214365be08ea2bfc26f26994bafb4235be314b9b4b0";
  };

  buildInputs = [ zlib readline ] ++ optionals (!stdenv.isDarwin) [ libossp_uuid ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = optional (!stdenv.isDarwin)
    ''
      --with-ossp-uuid
    '';

  patches = [ ./disable-resolve_symlinks.patch ./less-is-more.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.3";
  };

  meta = {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = "bsd";
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
