{ stdenv, fetchurl, zlib, readline, openssl }:

let version = "9.2.13"; in

stdenv.mkDerivation rec {
  name = "postgresql-${version}";

  src = fetchurl {
    url = "mirror://postgresql/source/v${version}/${name}.tar.bz2";
    sha256 = "0i3avdr8mnvn6ldkx0hc4jmclhisb2338hzs0j2m03wck8hddjsx";
  };

  outputs = [ "out" "doc" ];

  buildInputs = [ zlib readline openssl ];

  enableParallelBuilding = true;

  makeFlags = [ "world" ];

  configureFlags = stdenv.lib.optionals (!stdenv.isCygwin) [ "--with-openssl" ];

  patches = [ ./disable-resolve_symlinks.patch ./less-is-more.patch ];

  installTargets = [ "install-world" ];

  LC_ALL = "C";

  passthru = {
    inherit readline;
    psqlSchema = "9.2";
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
