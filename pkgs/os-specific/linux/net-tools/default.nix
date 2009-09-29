{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "net-tools-1.60";
  
  src = fetchurl {
    url = http://www.tazenda.demon.co.uk/phil/net-tools/net-tools-1.60.tar.bz2;
    md5 = "888774accab40217dde927e21979c165";
  };

  patches = [ ./net-tools-labels.patch ];
  
  preBuild =
    ''
      cp ${./config.h} config.h
    '';

  makeFlags = "BASEDIR=$(out) mandir=/share/man";

  meta = {
    homepage = http://www.tazenda.demon.co.uk/phil/net-tools/;
    description = "A set of tools for controlling the network subsystem in Linux";
    license = "GPLv2+";
    platforms = [ stdenv.lib.platforms.linux ];
  };
}
