{stdenv, fetchurl, perl}:

stdenv.mkDerivation rec {
  name = "lcov-1.12";

  src = fetchurl {
    url = "mirror://sourceforge/ltp/${name}.tar.gz";
    sha256 = "19wfifdpxxivhq9adbphanjfga9bg9spms9v7c3589wndjff8x5l";
  };

  buildInputs = [ perl ];

  preBuild = ''
    patchShebangs bin/
    makeFlagsArray=(PREFIX=$out BIN_DIR=$out/bin MAN_DIR=$out/share/man)
  '';

  meta = with stdenv.lib; {
    description = "Code coverage tool that enhances GNU gcov";

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

    maintainers = with maintainers; [ dezgeg mornfall ];
    platforms = platforms.all;
  };
}
