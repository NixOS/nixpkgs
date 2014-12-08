{ stdenv, fetchurl, zlib, readline, libossp_uuid, openssl }:

with stdenv.lib;

let version = "9.4rc1"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "6ce91d78fd6c306536f5734dbaca10889814b9d0fe0b38a41b3e635d95241c7c";
  };

  buildInputs = [ zlib readline openssl ] ++ optionals (!stdenv.isDarwin) [ libossp_uuid ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = [
    "--with-openssl"
    ]
    ++ optionals (!stdenv.isDarwin) ["--with-ossp-uuid"]
    ;

  patches = [
    ./disable-resolve_symlinks-94.patch
    ./less-is-more.patch
    ./postgresql-9.4-dont-check-private-key.patch
    ];

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
