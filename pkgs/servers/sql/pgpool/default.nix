{ stdenv, fetchurl, postgresql, openssl, pam ? null, libmemcached ? null }:

stdenv.mkDerivation rec {
  pname = "pgpool-II";
  version = "4.0.5";
  name = "${pname}-${version}";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.pgpool.net/download.php?f=${name}.tar.gz";
    sha256 = "0v2g2ksikn10kxsa8i47gv0kbklrsscvlddza3caf522q1k0fic4";
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
