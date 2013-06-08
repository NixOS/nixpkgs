{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "net-tools-1.60_p20120127084908";

  src = fetchurl {
    url = "mirror://gentoo/distfiles/${name}.tar.xz";
    sha256 = "408a51964aa142a4f45c4cffede2478abbd5630a7c7346ba0d3611059a2a3c94";
  };

  preBuild =
    ''
      cp ${./config.h} config.h
    '';

  makeFlags = "BASEDIR=$(out) mandir=/share/man";

  meta = {
    homepage = http://www.tazenda.demon.co.uk/phil/net-tools/;
    description = "A set of tools for controlling the network subsystem in Linux";
    license = "GPLv2+";
    platforms = stdenv.lib.platforms.linux;
  };
}
