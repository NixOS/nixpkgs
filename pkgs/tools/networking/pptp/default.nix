{ stdenv, fetchurl, perl, ppp, iproute, which }:

stdenv.mkDerivation rec {
  name = "pptp-${version}";
  version = "1.9.0";

  src = fetchurl {
    url = "mirror://sourceforge/pptpclient/${name}.tar.gz";
    sha256 = "00cj3jqj1hqri856jif4kkzan684qv1cb1zf2amzblvqqnzqq7hb";
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

  nativeBuildInputs = [ perl which ];

  meta = {
    description = "PPTP client for Linux";
    homepage = http://pptpclient.sourceforge.net/;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.urkud ];
  };
}
