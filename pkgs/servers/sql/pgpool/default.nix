{ lib, stdenv, fetchurl, postgresql, openssl, pam ? null, libmemcached ? null }:

stdenv.mkDerivation rec {
  pname = "pgpool-II";
  version = "4.3.2";

  src = fetchurl {
    name = "${pname}-${version}.tar.gz";
    url = "http://www.pgpool.net/download.php?f=${pname}-${version}.tar.gz";
    sha256 = "02jg0c6k259i0r927dng9h0y58q965swshg2c9mzqhazcdiga5ap";
  };

  buildInputs = [ postgresql openssl pam libmemcached ];

  configureFlags = [
    "--sysconfdir=/etc"
    "--localstatedir=/var"
    "--with-openssl"
  ] ++ lib.optional (pam != null) "--with-pam"
    ++ lib.optional (libmemcached != null) "--with-memcached=${libmemcached}";

  installFlags = [
    "sysconfdir=\${out}/etc"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://pgpool.net/mediawiki/index.php";
    description = "A middleware that works between postgresql servers and postgresql clients";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
