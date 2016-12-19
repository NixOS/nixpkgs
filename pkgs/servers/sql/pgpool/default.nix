{ stdenv, fetchurl, postgresql, openssl, pam ? null, libmemcached ? null }:

stdenv.mkDerivation rec {
  name = "pgpool-II-3.4.2";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "http://www.pgpool.net/download.php?f=${name}.tar.gz";
    sha256 = "0lf3fvwc2ib4md25a3hnv822nhy9ac06vg0ndw8q9bry66hzwcfh";
  };

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

  meta = with stdenv.lib; {
    homepage = http://pgpool.net/mediawiki/index.php;
    description = "A middleware that works between postgresql servers and postgresql clients";
    license = licenses.free;
    platforms = platforms.linux;
    maintainers = with maintainers; [ wkennington ];
  };
}
