{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "m4-1.4.11";
  src = fetchurl {
    url = "mirror://gnu/m4/${name}.tar.bz2";
    sha256 = "1bcakymxddxykg5vbll3d9xq17m5sa3r6cprf1k27x5k4mjnhz0b";
  };

  patches = [ ./SIGPIPE.patch ];

  # XXX: Work around Gnulib bug.  See:
  # http://thread.gmane.org/gmane.comp.gnu.m4.bugs/2478 .
  configureFlags="gl_cv_func_strtod_works=no";

  doCheck = true;

  meta = {
    homepage = http://www.gnu.org/software/m4/;
    description = "GNU M4, a macro processor";

    longDescription = ''
      GNU M4 is an implementation of the traditional Unix macro
      processor.  It is mostly SVR4 compatible although it has some
      extensions (for example, handling more than 9 positional
      parameters to macros).  GNU M4 also has built-in functions for
      including files, running shell commands, doing arithmetic, etc.

      GNU M4 is a macro processor in the sense that it copies its
      input to the output expanding macros as it goes.  Macros are
      either builtin or user-defined and can take any number of
      arguments.  Besides just doing macro expansion, m4 has builtin
      functions for including named files, running UNIX commands,
      doing integer arithmetic, manipulating text in various ways,
      recursion etc...  m4 can be used either as a front-end to a
      compiler or as a macro processor in its own right.
    '';

    license = "GPLv3+";
  };

}
