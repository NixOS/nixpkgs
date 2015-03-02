{ stdenv, fetchurl, zlib, readline, libossp_uuid }:

with stdenv.lib;

let version = "9.4.1"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "19n3i14bhmw8dacd2kl3n1wzj362qv3fjmal5vsvi580h9ybgp99";
  };

  buildInputs = [ zlib readline ] ++ optionals (!stdenv.isDarwin) [ libossp_uuid ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = optional (!stdenv.isDarwin)
    ''
      --with-ossp-uuid
    '';

  patches = [ ./disable-resolve_symlinks-94.patch ./less-is-more.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.4";
  };

  meta = {
    homepage = http://www.postgresql.org/ ;
    description = "A powerful, open source object-relational database system";
    license = stdenv.lib.licenses.postgresql;
    maintainers = with stdenv.lib.maintainers; [ aristid ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
