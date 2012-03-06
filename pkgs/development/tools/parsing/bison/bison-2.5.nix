{ stdenv, fetchurl, m4, perl }:

stdenv.mkDerivation rec {
  name = "bison-2.5";

  src = fetchurl {
    url = "mirror://gnu/bison/${name}.tar.bz2";
    sha256 = "1f1rai3v6k6xjii94964iq0alhc2hxwapqa363nfj8rbxvv0sdqa";
  };

  buildNativeInputs = [ m4 ]
    ++ stdenv.lib.optional doCheck perl;
  propagatedBuildInputs = [ m4 ];

  M4 = "m4";

  doCheck = true;

  meta = {
    description = "GNU Bison, a Yacc-compatible parser generator";

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

    homepage = http://www.gnu.org/software/bison/;

    license = "GPLv3+";

    maintainers = [ stdenv.lib.maintainers.ludo ];
  };

  passthru = { glrSupport = true; };
}
