{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.6.0";

  src = fetchurl {
    url = "http://www.ivarch.com/programs/sources/${name}.tar.bz2";
    sha256 = "13gg6r84pkvznpd1l11qw1jw9yna40gkgpni256khyx21m785khf";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = stdenv.lib.licenses.artistic2;
    maintainers = with stdenv.lib.maintainers; [ viric jgeerds ];
    platforms = with stdenv.lib.platforms; all;
  };
}
