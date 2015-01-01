{ stdenv, fetchurl, zlib, readline, libossp_uuid, openssl }:

with stdenv.lib;

let version = "9.4.0"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "7a35c3cb77532f7b15702e474d7ef02f0f419527ee80a4ca6036fffb551625a5";
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
