{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "lcov-1.10";

  src = fetchurl {
    url = "mirror://sourceforge/ltp/${name}.tar.gz";
    sha256 = "13xq2ln4jjasslqzzhr5g11q1c19gwpng1jphzbzmylmrjz62ila";
  };

  patches =
    [ ./lcov-except-unreach.patch ./no-warn-missing.patch ]
    ++ stdenv.lib.optional stdenv.isFreeBSD ./freebsd-install.patch;

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

  meta = with stdenv.lib; {
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
    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ maintainers.mornfall ];
    platforms = platforms.all;
  };
}
