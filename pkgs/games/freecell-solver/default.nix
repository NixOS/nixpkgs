{ stdenv, fetchurl, pkgconfig, cmake, perl, gmp, libtap, perlPackages }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "freecell-solver-${version}";
  version = "3.26.0";

  src = fetchurl {
    url = "http://fc-solve.shlomifish.org/downloads/fc-solve/${name}.tar.bz2";
    sha256 = "0pm6xk4fmwgzva70qxb0pqymdfvpasnvqiwwmm8hpx7g37y11wqk";
  };

  buildInputs = [ pkgconfig cmake perl gmp libtap
    perlPackages.TemplateToolkit perlPackages.StringShellQuote
    perlPackages.GamesSolitaireVerify ];

  meta = {
    description = "A FreeCell automatic solver";
    longDescription = ''
      FreeCell Solver is a program that automatically solves layouts
      of Freecell and similar variants of Card Solitaire such as Eight
      Off, Forecell, and Seahaven Towers, as well as Simple Simon
      boards.
    '';
    homepage = http://fc-solve.shlomifish.org/;
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.unix;
  };
}
