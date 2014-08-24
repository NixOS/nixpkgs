{ stdenv, fetchurl, gzip, popt }:

stdenv.mkDerivation rec {
  name = "logrotate-3.8.7";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/o/logrotate/${name}.tar.gz";
    sha256 = "0r1bs40gwi8awx6rjq3n4lw9fgws97ww2li7z87683p380gnkfpn";
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
