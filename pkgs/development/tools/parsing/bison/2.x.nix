{ stdenv, fetchurl, m4, perl }:

stdenv.mkDerivation rec {
  name = "bison-2.7";

  src = fetchurl {
    url = "mirror://gnu/bison/${name}.tar.gz";
    sha256 = "0cd8s2g7zjshya7kwjc9rh3drsssl4hiq4sccnkgf0nn9wvygfqr";
  };

  nativeBuildInputs = [ m4 ] ++ stdenv.lib.optional doCheck perl;
  propagatedBuildInputs = [ m4 ];

  doCheck = true;
  # M4 = "${m4}/bin/m4";

  meta = {
    homepage = "http://www.gnu.org/software/bison/";
    description = "Yacc-compatible parser generator";
    license = stdenv.lib.licenses.gpl3Plus;

    longDescription = ''
      Bison is a general-purpose parser generator that converts an
      annotated context-free grammar into an LALR(1) or GLR parser for
      that grammar.  Once you are proficient with Bison, you can use
      it to develop a wide range of language parsers, from those used
      in simple desk calculators to complex programming languages.

      Bison is upward compatible with Yacc: all properly-written Yacc
      grammars ought to work with Bison with no change.  Anyone
      familiar with Yacc should be able to use Bison with little
      trouble.  You need to be fluent in C or C++ programming in order
      to use Bison.
    '';

    platforms = stdenv.lib.platforms.unix;
  };

  passthru = { glrSupport = true; };
}
