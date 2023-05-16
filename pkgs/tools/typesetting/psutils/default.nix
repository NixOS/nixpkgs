{ lib, stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  pname = "psutils";
  version = "17";

  src = fetchurl {
<<<<<<< HEAD
    url = "http://knackered.knackered.org/angus/download/${pname}/${pname}-p${version}.tar.gz";
    hash = "sha256-OFPreVhLqPvieoFUJbZan38Vsljg1DoFqFa9t11YiuQ=";
=======
    url = "ftp://ftp.knackered.org/pub/psutils/psutils-p${version}.tar.gz";
    sha256 = "1r4ab1fvgganm02kmm70b2r1azwzbav2am41gbigpa2bb1wynlrq";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  configurePhase = ''
    sed -e 's,/usr/local/bin/perl,${perl}/bin/perl,' \
      -e "s,/usr/local,$out," \
      Makefile.unix > Makefile
  '';

<<<<<<< HEAD
  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preInstall = ''
    mkdir -p $out/bin $out/share/man/man1
  '';

<<<<<<< HEAD
  meta = {
    description = "Collection of useful utilities for manipulating PS documents";
    homepage = "http://knackered.knackered.org/angus/psutils/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Collection of useful utilities for manipulating PS documents";
    homepage = "http://knackered.knackered.org/angus/psutils/";
    license = licenses.bsd3;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
