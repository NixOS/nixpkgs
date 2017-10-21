{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "psutils-17";

  src = fetchurl {
    url = "ftp://ftp.knackered.org/pub/psutils/psutils-p17.tar.gz";
    sha256 = "1r4ab1fvgganm02kmm70b2r1azwzbav2am41gbigpa2bb1wynlrq";
  };

  configurePhase = ''
    sed -e 's,/usr/local/bin/perl,${perl}/bin/perl,' \
      -e "s,/usr/local,$out," \
      Makefile.unix > Makefile
  '';

  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = with stdenv.lib; {
    description = "Collection of useful utilities for manipulating PS documents";
    homepage = http://knackered.knackered.org/angus/psutils/;
    license = licenses.bsd3;
  };
}
