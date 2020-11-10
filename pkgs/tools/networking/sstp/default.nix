{ stdenv, fetchurl, pkgconfig, ppp, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "sstp-client";
  version = "1.0.13";

  src = fetchurl {
    url = "mirror://sourceforge/sstp-client/sstp-client/sstp-client-${version}.tar.gz";
    sha256 = "06rjyncmgdy212xf9l9z6mfh4gdmgk7l4y841gb8lpbrl3y5h4ln";
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
    homepage = "http://sstp-client.sourceforge.net/";
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.ktosiek ];
    license = stdenv.lib.licenses.gpl2;
  };
}
