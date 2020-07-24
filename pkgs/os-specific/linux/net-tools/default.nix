{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "net-tools";
  version = "1.60_p20180626073013";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${pname}-${version}.tar.xz";
    sha256 = "0mzsjjmz5kn676w2glmxwwd8bj0xy9dhhn21aplb435b767045q4";
  };

  preBuild =
    ''
      cp ${./config.h} config.h
    '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "AR=${stdenv.cc.targetPrefix}ar"
    "BASEDIR=$(out)"
    "mandir=/share/man"
    "HAVE_ARP_TOOLS=1"
    "HAVE_PLIP_TOOLS=1"
    "HAVE_SERIAL_TOOLS=1"
    "HAVE_HOSTNAME_TOOLS=1"
    "HAVE_HOSTNAME_SYMLINKS=1"
  ];

  meta = {
    homepage = "http://net-tools.sourceforge.net/";
    description = "A set of tools for controlling the network subsystem in Linux";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
