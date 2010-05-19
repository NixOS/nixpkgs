{stdenv, fetchurl, gzip, popt}:

stdenv.mkDerivation rec {
  name = "logrotate-3.7.8";

  src = fetchurl {
    url = https://fedorahosted.org/releases/l/o/logrotate/logrotate-3.7.8.tar.gz;
    sha256 = "1p9nqmznqvzn03saw3jxa8xwsdqym8jr778rwig8kk786343vai1";
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
    homepage = "https://fedorahosted.org/releases/l/o/logrotate/";
    description = "Rotates and compresses system logs";
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; all;
  };

}
