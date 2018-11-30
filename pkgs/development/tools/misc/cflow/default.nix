{ stdenv, fetchurl, gettext, emacs }:

stdenv.mkDerivation rec {
  name = "cflow-1.5";

  src = fetchurl {
    url = "mirror://gnu/cflow/${name}.tar.bz2";
    sha256 = "0yq33k5ap1zpnja64n89iai4zh018ffr72wki5a6mzczd880mr3g";
  };

  patchPhase = ''
    substituteInPlace "src/cflow.h"					\
      --replace "/usr/bin/cpp"						\
                "$(cat ${stdenv.cc}/nix-support/orig-cc)/bin/cpp"
  '';

  buildInputs = [ gettext ] ++
    # We don't have Emacs/GTK/etc. on {Dar,Cyg}win.
    stdenv.lib.optional
      (! (stdenv.lib.lists.any (x: stdenv.hostPlatform.system == x)
              [ "i686-cygwin" ]))
      emacs;

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Tool to analyze the control flow of C programs";

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

    license = licenses.gpl3Plus;

    homepage = http://www.gnu.org/software/cflow/;

    maintainers = [ maintainers.vrthra ];

    /* On Darwin, build fails with:

       Undefined symbols:
         "_argp_program_version", referenced from:
             _argp_program_version$non_lazy_ptr in libcflow.a(argp-parse.o)
       ld: symbol(s) not found
     */
    platforms = platforms.linux;
  };
}
