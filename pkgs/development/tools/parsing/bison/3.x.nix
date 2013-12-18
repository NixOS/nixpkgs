{ stdenv, fetchurl, m4, perl, flex }:

stdenv.mkDerivation rec {
  name = "bison-3.0.2";

  src = fetchurl {
    url = "mirror://gnu/bison/${name}.tar.xz";
    sha256 = "0g4gjan477lac18m51kv4xzcsp6wjfsfwvd2dxymcl6vid9fihx2";
  };

  nativeBuildInputs = [ m4 ] ++ stdenv.lib.optionals doCheck [perl flex];
  propagatedBuildInputs = [ m4 ];

  doCheck = true;

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

    maintainers = [ stdenv.lib.maintainers.simons ];
    platforms = stdenv.lib.platforms.unix;
  };

  passthru = { glrSupport = true; };
}
