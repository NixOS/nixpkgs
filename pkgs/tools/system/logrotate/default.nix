{ stdenv, fetchurl, gzip, popt }:

stdenv.mkDerivation rec {
  name = "logrotate-3.9.1";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/l/o/logrotate/${name}.tar.gz";
    sha256 = "0i95qnacv5wf7kfkcpi38ys3i14fr01ifhm8b4ari04c53inj9q2";
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
