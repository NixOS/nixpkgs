{ lib, stdenv, fetchurl, perl, ppp, iproute2 }:

stdenv.mkDerivation rec {
  pname = "pptp";
  version = "1.10.0";

  src = fetchurl {
    url = "mirror://sourceforge/pptpclient/${pname}-${version}.tar.gz";
    sha256 = "1x2szfp96w7cag2rcvkdqbsl836ja5148zzfhaqp7kl7wjw2sjc2";
  };

  prePatch = ''
    substituteInPlace Makefile --replace 'install -o root' 'install'
  '';

  preConfigure = ''
    makeFlagsArray=( IP=${iproute2}/bin/ip PPPD=${ppp}/sbin/pppd \
                     BINDIR=$out/sbin MANDIR=$out/share/man/man8 \
                     PPPDIR=$out/etc/ppp )
  '';

  buildInputs = [ perl ];

  postFixup = ''
    patchShebangs $out
  '';

  meta = with lib; {
    description = "PPTP client for Linux";
    homepage = "https://pptpclient.sourceforge.net/";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
