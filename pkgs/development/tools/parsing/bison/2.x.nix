{ stdenv, fetchurl, m4, perl }:

stdenv.mkDerivation rec {
  name = "bison-2.6.5";

  src = fetchurl {
    url = "mirror://gnu/bison/${name}.tar.xz";
    sha256 = "8640d5b51aad462db6863711f333a9159836853e0b1e79fdef708c6efb5cd52b";
  };

  nativeBuildInputs = [ m4 ] ++ stdenv.lib.optional doCheck perl;
  propagatedBuildInputs = [ m4 ];

  doCheck = true;
  # M4 = "${m4}/bin/m4";

  meta = {
    homepage = "http://www.gnu.org/software/bison/";
    description = "GNU Bison, a Yacc-compatible parser generator";
    license = "GPLv3+";

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

    maintainers = [ stdenv.lib.maintainers.ludo stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };

  passthru = { glrSupport = true; };
}
