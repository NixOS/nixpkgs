{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wdiff-0.6.1";
  
  src = fetchurl {
    url = "http://alpha.gnu.org/gnu/wdiff/${name}.tar.gz";
    sha256 = "0cgmx9k8sj0l79kp4m2lmn4ifx55ah68q4qk7xsanx69m1061ghf";
  };

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/wdiff/;
    description = "GNU wdiff, comparing files on a word by word basis";
    license = "GPLv3+";
    maintainers = [ stdenv.lib.maintainers.eelco stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
