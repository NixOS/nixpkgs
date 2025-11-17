{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
}:

stdenv.mkDerivation rec {
  pname = "net-tools";
  version = "2.10";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}-${version}.tar.xz";
    sha256 = "sha256-smJDWlJB6Jv6UcPKvVEzdTlS96e3uT8y4Iy52W9YDWk=";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2025-46836.patch";
      url = "https://github.com/ecki/net-tools/commit/7a8f42fb20013a1493d8cae1c43436f85e656f2d.patch";
      hash = "sha256-2R9giETNN3e2t1DPQj0kb4uYCXpkBxnF8grWIBLM7s0=";
    })
  ];

  preBuild = ''
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
    description = "Set of tools for controlling the network subsystem in Linux";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
