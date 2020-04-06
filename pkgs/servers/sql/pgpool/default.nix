{ stdenv, fetchurl, postgresql, openssl, pam ? null, libmemcached ? null }:

stdenv.mkDerivation rec {
  pname = "pgpool-II";
  version = "4.0.6";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "http://www.pgpool.net/download.php?f=${pname}-${version}.tar.gz";
    sha256 = "0blmbqczyrgzykby2z3xzmhzd8kgij9izxv50n5cjn5azf7dn8g5";
  };

  patches = [ ./pgpool.patch ];

  buildInputs = [ postgresql openssl pam libmemcached ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openssl"
  ] ++ stdenv.lib.optional (pam != null) "--with-pam"
    ++ stdenv.lib.optional (libmemcached != null) "--with-memcached=${libmemcached}";

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://pgpool.net/mediawiki/index.php;
    description = "A middleware that works between postgresql servers and postgresql clients";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
