{ lib, stdenv, fetchurl, pkg-config, ppp, libevent, openssl }:

stdenv.mkDerivation rec {
  pname = "sstp-client";
  version = "1.0.16";

  src = fetchurl {
    url = "mirror://sourceforge/sstp-client/sstp-client/sstp-client-${version}.tar.gz";
    sha256 = "sha256-r74U/RIveHX0+tDtmC0XRRNtLmbMNrl/cu8aERF4TKE=";
  };

  postPatch = ''
    sed 's,/usr/sbin/pppd,${ppp}/sbin/pppd,' -i src/sstp-pppd.c
    sed "s,sstp-pppd-plugin.so,$out/lib/pppd/sstp-pppd-plugin.so," -i src/sstp-pppd.c
  '';

  configureFlags = [
    "--with-openssl=${openssl.dev}"
    "--with-runtime-dir=/run/sstpc"
    "--with-pppd-plugin-dir=$(out)/lib/pppd"
  ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libevent openssl ppp ];

  meta = with lib; {
    description = "SSTP client for Linux";
    homepage = "http://sstp-client.sourceforge.net/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ ktosiek ];
    license = licenses.gpl2Plus;
  };
}
