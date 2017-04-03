{ stdenv, fetchurl, pkgconfig, cmake
, perl, gmp, libtap, gperf
, perlPackages, python3Packages }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "freecell-solver-${version}";
  version = "4.8.0";

  src = fetchurl {
    url = "http://fc-solve.shlomifish.org/downloads/fc-solve/${name}.tar.xz";
    sha256 = "0274l1p71ps222i62whqfkg80fcc8m4w2hmpbrbbd5gh8kfpman3";
  };

  buildInputs = [ pkgconfig cmake perl gmp libtap gperf
    perlPackages.TemplateToolkit perlPackages.StringShellQuote
    perlPackages.GamesSolitaireVerify perlPackages.TaskFreecellSolverTesting
    python3Packages.python python3Packages.random2 ];

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
    platforms = platforms.unix;
  };
}
