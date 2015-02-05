{ stdenv, fetchurl, ppp, libevent, openssl }:

stdenv.mkDerivation rec {
  name = "sstp-client-${version}";
  version = "1.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/sstp-client/sstp-client/${version}/sstp-client-${version}.tar.gz";
    sha256 = "0kpwywbavmlgid07rk8ff0bxp75bnfa1nc28w4j0pkxjhmja5n6k";
  };

  patchPhase =
    ''
      sed 's,/usr/sbin/pppd,${ppp}/sbin/pppd,' -i src/sstp-pppd.c
      sed "s,sstp-pppd-plugin.so,$out/lib/pppd/sstp-pppd-plugin.so," -i src/sstp-pppd.c
    '';

  configureFlags = [
    "--with-openssl=${openssl}"
    "--with-runtime-dir=/run/sstpc"
    "--with-pppd-plugin-dir=$(out)/lib/pppd"
  ];

  buildInputs = [ libevent openssl ppp ];

  meta = {
    description = "SSTP client for Linux";
    homepage = http://sstp-client.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ktosiek ];
  };
}
