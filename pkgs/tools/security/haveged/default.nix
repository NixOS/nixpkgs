{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "haveged";
  version = "1.9.2";

  src = fetchurl {
    url = "http://www.issihosts.com/haveged/haveged-${version}.tar.gz";
    sha256 = "0w5ypz6451msckivjriwyw8djydlwffam7x23xh626s2vzdrlzgp";
  };

  meta = {
    description = "A simple entropy daemon";
    longDescription = ''
      The haveged project is an attempt to provide an easy-to-use, unpredictable
      random number generator based upon an adaptation of the HAVEGE algorithm.
      Haveged was created to remedy low-entropy conditions in the Linux random device
      that can occur under some workloads, especially on headless servers. Current development
      of haveged is directed towards improving overall reliability and adaptability while minimizing
      the barriers to using haveged for other tasks.
    '';
    homepage = http://www.issihosts.com/haveged/;
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.domenkozar ];
    platforms = stdenv.lib.platforms.unix;
  };
}
