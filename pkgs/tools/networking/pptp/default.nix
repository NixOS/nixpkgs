{ stdenv, fetchurl, perl, ppp, iproute }:

stdenv.mkDerivation rec {
  name = "pptp-1.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/pptpclient/${name}.tar.gz";
    sha256 = "1g4lfv9vhid4v7kx1mlfcrprj3h7ny6g4kv564qzlf9abl3f12p9";
  };

  patchPhase =
    ''
      sed -e 's/install -o root/install/' -i Makefile
      sed -e 's,/bin/ip,${iproute}/sbin/ip,' -i routing.c
    '';
  preConfigure =
    ''
      makeFlagsArray=( PPPD=${ppp}/sbin/pppd BINDIR=$out/sbin \
          MANDIR=$out/share/man/man8 PPPDIR=$out/etc/ppp )
    '';

  nativeBuildInputs = [ perl ];

  meta = {
    description = "PPTP client for Linux";
    homepage = http://pptpclient.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
