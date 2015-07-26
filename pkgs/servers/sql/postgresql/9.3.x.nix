{ stdenv, fetchurl, zlib, readline, libossp_uuid, openssl}:

with stdenv.lib;

let version = "9.3.9"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0j85j69rf54cwz5yhrhk4ca22b82990j5sqb8cr1fl9843nd0fzp";
  };

  outputs = [ "out" "doc" ];

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

  meta = with stdenv.lib; {
    homepage = http://www.postgresql.org/;
    description = "A powerful, open source object-relational database system";
    license = licenses.postgresql;
    maintainers = [ maintainers.ocharles ];
    platforms = platforms.unix;
    hydraPlatforms = platforms.linux;
  };
}
