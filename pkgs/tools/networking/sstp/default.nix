{ stdenv, fetchurl, pkgconfig, ppp, libevent, openssl }:

stdenv.mkDerivation rec {
  name = "sstp-client-${version}";
  version = "1.0.12";

  src = fetchurl {
    url = "mirror://sourceforge/sstp-client/sstp-client/${version}/sstp-client-${version}.tar.gz";
    sha256 = "1zv7rx6wh9rhbyg9pg6759by8hc6n4162zrrw0y812cnaw3b8zj8";
  };

  patchPhase =
    ''
      sed 's,/usr/sbin/pppd,${ppp}/sbin/pppd,' -i src/sstp-pppd.c
      sed "s,sstp-pppd-plugin.so,$out/lib/pppd/sstp-pppd-plugin.so," -i src/sstp-pppd.c
    '';

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-runtime-dir=/run/sstpc"
    "--with-pppd-plugin-dir=$(out)/lib/pppd"
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libevent openssl ppp ];

  meta = {
    description = "SSTP client for Linux";
    homepage = http://sstp-client.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ktosiek ];
    license = stdenv.lib.licenses.gpl2;
  };
}
