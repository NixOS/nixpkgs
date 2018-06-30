{ stdenv, fetchurl } :

stdenv.mkDerivation rec {
  name = "pv-1.6.6";

  src = fetchurl {
    url = "http://www.ivarch.com/programs/sources/${name}.tar.bz2";
    sha256 = "1wbk14xh9rfypiwyy68ssl8dliyji30ly70qki1y2xx3ywszk3k0";
  };

  meta = {
    homepage = http://www.ivarch.com/programs/pv;
    description = "Tool for monitoring the progress of data through a pipeline";
    license = stdenv.lib.licenses.artistic2;
    maintainers = with stdenv.lib.maintainers; [ viric jgeerds ];
    platforms = with stdenv.lib.platforms; all;
  };
}
