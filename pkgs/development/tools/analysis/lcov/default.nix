{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "lcov-1.7";
  
  src = fetchurl {
    url = "mirror://sourceforge/ltp/${name}.tar.gz";
    sha256 = "1cx3haizs0rw6wjsn486qcn50f3qpybflkkb1780cg6s8jzcwdin";
  };

  preBuild = ''
    makeFlagsArray=(PREFIX=$out BIN_DIR=$out/bin MAN_DIR=$out/share/man)
  '';

  preInstall = ''
    substituteInPlace bin/install.sh --replace /bin/bash $shell
  '';

  postInstall = ''
    for i in $out/bin/*; do
      substituteInPlace $i --replace /usr/bin/perl ${perl}/bin/perl
    done
  ''; # */

  meta = {
    description = "A code coverage tool for Linux";
    homepage = http://ltp.sourceforge.net/coverage/lcov.php;
  };
}
