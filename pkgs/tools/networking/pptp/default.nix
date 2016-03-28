{ stdenv, fetchurl, perl, ppp, iproute, which }:

stdenv.mkDerivation rec {
  name = "pptp-1.8.0";

  src = fetchurl {
    url = "mirror://sourceforge/pptpclient/${name}.tar.gz";
    sha256 = "1nmvwj7wd9c1isfi9i0hdl38zv55y2khy2k0v1nqlai46gcl5773";
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
