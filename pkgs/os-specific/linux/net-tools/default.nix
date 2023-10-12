{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "net-tools";
  version = "2.10";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-smJDWlJB6Jv6UcPKvVEzdTlS96e3uT8y4Iy52W9YDWk=";
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
    "HAVE_MII=1"
  ];

  meta = {
    homepage = "http://net-tools.sourceforge.net/";
    description = "A set of tools for controlling the network subsystem in Linux";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
