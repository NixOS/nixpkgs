{ stdenv, fetchurl, gzip, popt }:

stdenv.mkDerivation rec {
  name = "logrotate-3.8.3";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/o/logrotate/${name}.tar.gz";
    sha256 = "0xqrz8xzs2c1vx8l5h9lp2ciwwifj7y52xsppb1vrvbi254vyxh7";
  };

  # Logrotate wants to access the 'mail' program; to be done.
  patchPhase = ''
    sed -i -e 's,[a-z/]\+gzip,${gzip}/bin/gzip,' \
           -e 's,[a-z/]\+gunzip,${gzip}/bin/gunzip,' config.h
  '';

  preBuild = ''
    makeFlags="BASEDIR=$out"
  '';

  buildInputs = [ popt ];

  meta = {
    homepage = https://fedorahosted.org/releases/l/o/logrotate/;
    description = "Rotates and compresses system logs";
    license = "GPLv2+";
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.all;
  };

}
