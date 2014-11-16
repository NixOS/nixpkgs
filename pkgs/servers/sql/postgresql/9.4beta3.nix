{ stdenv, fetchurl, zlib, readline, libossp_uuid }:

with stdenv.lib;

let version = "9.4beta3"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0pdawsmrzwgf2c4g18xlgzv6q34kd8q2p1nxag0xaw4sbdmdilas";
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
