{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "lcov-1.6";
  
  src = fetchurl {
    url = mirror://sourceforge/ltp/lcov-1.6.tar.gz;
    sha256 = "0d6lb0vlj3lvqmm678jic9h25q4dnlkbv37wg5yj311hdr9ls1kx";
  };

  patches = [
    # http://ltp.cvs.sourceforge.net/ltp/utils/analysis/lcov/bin/geninfo?revision=1.33&view=markup&pathrev=HEAD
    ./string.patch
  ];

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
