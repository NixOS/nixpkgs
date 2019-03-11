{ stdenv, fetchurl, postgresql, openssl, pam ? null, libmemcached ? null }:

stdenv.mkDerivation rec {
  name = "pgpool-II-3.4.14";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.pgpool.net/download.php?f=${name}.tar.gz";
    sha256 = "1paak83f4lv48xckmf2znryrvhmdz86w4v97mcw2gxm50hcl74sw";
  };

  patches = [ ./pgpool-II-3.4.14-glibc-2.26.patch ];

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
