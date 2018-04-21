{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "net-tools-${version}";
  version = "1.60_p20170221182432";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${name}.tar.xz";
    sha256 = "08r4r2a24g5bm8jwgfa998gs1fld7fgbdf7pilrpsw1m974xn04a";
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
