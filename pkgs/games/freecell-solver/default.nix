{ stdenv, fetchurl, pkgconfig, cmake
, perl, gmp, libtap, gperf
, perlPackages, python3 }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "freecell-solver-${version}";
  version = "4.18.0";

  src = fetchurl {
    url = "https://fc-solve.shlomifish.org/downloads/fc-solve/${name}.tar.xz";
    sha256 = "1cmaib69pijmcpvgjvrdry8j4xys8l906l80b8z21vvyhdwrfdnn";
  };

  nativeBuildInputs = [
    cmake perl pkgconfig
  ] ++ (with perlPackages; TaskFreecellSolverTesting.buildInputs ++ [
    GamesSolitaireVerify StringShellQuote TaskFreecellSolverTesting TemplateToolkit
  ]);

  buildInputs = [
    gmp libtap gperf
    python3 python3.pkgs.random2
  ];

  # "ninja t/CMakeFiles/delta-states-test.t.exe.dir/__/delta_states.c.o" fails
  # to depend on the generated "is_king.h".
  enableParallelBuilding = false;

  meta = {
    description = "A FreeCell automatic solver";
    longDescription = ''
      FreeCell Solver is a program that automatically solves layouts
      of Freecell and similar variants of Card Solitaire such as Eight
      Off, Forecell, and Seahaven Towers, as well as Simple Simon
      boards.
    '';
    homepage = https://fc-solve.shlomifish.org/;
    license = licenses.mit;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.unix;
  };
}
