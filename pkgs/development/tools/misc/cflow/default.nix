{ stdenv, fetchurl, gettext, emacs }:

stdenv.mkDerivation rec {
  name = "cflow-1.2";

  src = fetchurl {
    url = "mirror://gnu/cflow/${name}.tar.bz2";
    sha256 = "0b45b1x1g9i23mv68pjl008qm4lkbd62hka2bf2gkjd2n4nalc6v";
  };

  buildInputs = [ gettext emacs ];

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
  };
}
