{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "lcov-1.9";

  src = fetchurl {
    url = "mirror://sourceforge/ltp/${name}.tar.gz";
    sha256 = "1jhs1x2qy5la5gpdfl805zm11rsz6anla3b0wffk6wq79xfi4zn3";
  };

  patches =
    [ ./find-source.patch ]
    ++ (stdenv.lib.optional stdenv.isFreeBSD ./freebsd-install.patch);

  preBuild = ''
    makeFlagsArray=(PREFIX=$out BIN_DIR=$out/bin MAN_DIR=$out/share/man)
  '';

  preInstall = ''
    substituteInPlace bin/install.sh --replace /bin/bash $shell
  '';

  postInstall = ''
    for i in "$out/bin/"*; do
      substituteInPlace $i --replace /usr/bin/perl ${perl}/bin/perl
    done
  '';

  meta = {
    description = "LCOV, a code coverage tool that enhances GNU gcov";

    longDescription =
      '' LCOV is an extension of GCOV, a GNU tool which provides information
         about what parts of a program are actually executed (i.e.,
         "covered") while running a particular test case.  The extension
         consists of a set of PERL scripts which build on the textual GCOV
         output to implement the following enhanced functionality such as
         HTML output.
      '';

    homepage = http://ltp.sourceforge.net/coverage/lcov.php;
    license = "GPLv2+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.all;
  };
}
