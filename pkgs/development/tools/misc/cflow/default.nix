{ stdenv, fetchurl, gettext, emacs }:

stdenv.mkDerivation rec {
  name = "cflow-1.4";

  src = fetchurl {
    url = "mirror://gnu/cflow/${name}.tar.bz2";
    sha256 = "1jkbq97ajcf834z68hbn3xfhiz921zhn39gklml1racf0kb3jzh3";
  };

  patchPhase = ''
    substituteInPlace "src/cflow.h"					\
      --replace "/usr/bin/cpp"						\
                "$(cat ${stdenv.gcc}/nix-support/orig-gcc)/bin/cpp"
  '';

  buildInputs = [ gettext ] ++
    # We don't have Emacs/GTK/etc. on {Dar,Cyg}win.
    stdenv.lib.optional
      (! (stdenv.lib.lists.any (x: stdenv.system == x)
              [ "i686-cygwin" ]))
      emacs;

  doCheck = true;

  meta = {
    description = "GNU cflow, a tool to analyze the control flow of C programs";

    longDescription = ''
      GNU cflow analyzes a collection of C source files and prints a
      graph, charting control flow within the program.

      GNU cflow is able to produce both direct and inverted flowgraphs
      for C sources.  Optionally a cross-reference listing can be
      generated.  Two output formats are implemented: POSIX and GNU
      (extended).

      The package also provides Emacs major mode for examining the
      produced flowcharts in Emacs.
    '';

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/cflow/;

    maintainers = [ stdenv.lib.maintainers.ludo ];

    /* On Darwin, build fails with:

       Undefined symbols:
         "_argp_program_version", referenced from:
             _argp_program_version$non_lazy_ptr in libcflow.a(argp-parse.o)
       ld: symbol(s) not found
     */
    platforms = stdenv.lib.platforms.linux;
  };
}
