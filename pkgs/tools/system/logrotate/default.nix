{ stdenv, fetchurl, gzip, popt }:

stdenv.mkDerivation rec {
  name = "logrotate-3.8.9";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/o/logrotate/${name}.tar.gz";
    sha256 = "19yzs7gc8ixr6iqq22n5gbixmvzsgmwp96kp4jiwr8bjj37df3kh";
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
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.viric ];
    platforms = stdenv.lib.platforms.all;
  };

}
