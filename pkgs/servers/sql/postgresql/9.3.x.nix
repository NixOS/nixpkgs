{ stdenv, fetchurl, zlib, readline, libossp_uuid, openssl}:

with stdenv.lib;

let version = "9.3.7"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0ggz0i91znv053zx9qas7pjf93s5by3dk84z1jxbjkg8yyrnlx4b";
  };

  buildInputs = [ zlib readline openssl ]
                ++ optionals (!stdenv.isDarwin) [ libossp_uuid ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = [ "--with-openssl" ]
                   ++ optional (!stdenv.isDarwin) "--with-ossp-uuid";

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
    license = stdenv.lib.licenses.postgresql;
    maintainers = [ stdenv.lib.maintainers.ocharles ];
    hydraPlatforms = stdenv.lib.platforms.linux;
  };
}
