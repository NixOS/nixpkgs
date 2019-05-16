{ stdenv, fetchurl, perl, ppp, iproute, which }:

stdenv.mkDerivation rec {
  name = "pptp-${version}";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/pptpclient/${name}.tar.gz";
    sha256 = "1x2szfp96w7cag2rcvkdqbsl836ja5148zzfhaqp7kl7wjw2sjc2";
  };

  patchPhase =
    ''
      sed -e 's/install -o root/install/' -i Makefile
    '';
  preConfigure =
    ''
      makeFlagsArray=( IP=${iproute}/bin/ip PPPD=${ppp}/sbin/pppd \
                       BINDIR=$out/sbin MANDIR=$out/share/man/man8 \
                       PPPDIR=$out/etc/ppp )
    '';

  nativeBuildInputs = [ perl which ];

  meta = with stdenv.lib; {
    description = "PPTP client for Linux";
    homepage = http://pptpclient.sourceforge.net/;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
