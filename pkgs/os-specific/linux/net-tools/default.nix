{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "net-tools-1.60_p20161110235919";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${name}.tar.xz";
    sha256 = "1kbgwkys45kb5wqhchi1kf0sfw93c1cl0hgyw7yhacxzdfxjmdfr";
  };

  preBuild =
    ''
      cp ${./config.h} config.h
    '';

  makeFlags = [
    "BASEDIR=$(out)"
    "mandir=/share/man"
    "HAVE_ARP_TOOLS=1"
    "HAVE_PLIP_TOOLS=1"
    "HAVE_SERIAL_TOOLS=1"
    "HAVE_HOSTNAME_TOOLS=1"
    "HAVE_HOSTNAME_SYMLINKS=1"
  ];

  meta = {
    homepage = http://net-tools.sourceforge.net/;
    description = "A set of tools for controlling the network subsystem in Linux";
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
