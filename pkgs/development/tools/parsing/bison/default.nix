{ stdenv, fetchurl, m4, perl, help2man }:

stdenv.mkDerivation rec {
  pname = "bison";
  version = "3.5";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1l8k2fcklwy0y57yidxvk5lbf0kb96ci3zffg2djivk8k05j0dhb";
  };

  nativeBuildInputs = [ m4 perl ] ++ stdenv.lib.optional stdenv.isSunOS help2man;
  propagatedBuildInputs = [ m4 ];

  doCheck = false; # fails
  doInstallCheck = false; # fails

  meta = {
    homepage = https://www.gnu.org/software/bison/;
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
