{ cabal, fetchurl, happy }:

let
  pname = "ebnf2ps";
  version = "1.0.8";
in
cabal.mkDerivation (self: {
  inherit pname version;

  src = fetchurl {
    url = "http://www.informatik.uni-freiburg.de/~thiemann/haskell/ebnf2ps/${pname}-${version}.tar.gz";
    sha256 = "1yfgq4nf79g1nyfb0yxqi887kxc04dvwpm1fwrk50bs4xj1vg3wf";
  };

  buildTools = [ happy ];

  patches = [ ./modernize.patch ];

  meta = {
    homepage = "http://www.informatik.uni-freiburg.de/~thiemann/haskell/ebnf2ps/";
    description = "Syntax Diagram Drawing Tool";
    license = "BSD";

    longDescription = ''
      Ebnf2ps generates nice looking syntax diagrams in EPS and FIG
      format from EBNF specifications and from yacc, bison, and Happy
      input grammars. The diagrams can be immediatedly included in
      TeX/LaTeX documents and in texts created with other popular
      document preparation systems.
    '';

    platforms = self.stdenv.lib.platforms.linux;
    maintainers = [ self.stdenv.lib.maintainers.simons ];
  };
})
