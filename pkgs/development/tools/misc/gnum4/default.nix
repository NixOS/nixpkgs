{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnum4-1.4.16";

  src = fetchurl {
    url = mirror://gnu/m4/m4-1.4.16.tar.bz2;
    sha256 = "035r7ma272j2cwni2961jp22k6bn3n9xwn3b3qbcn2yrvlghql22";
  };

  doCheck = !stdenv.isDarwin
    && !stdenv.isCygwin                    # XXX: `test-dup2' fails on Cygwin
    && !stdenv.isSunOS;                    # XXX: `test-setlocale2.sh' fails

  # Upstream is aware of it; it may be in the next release.
  patches = [ ./s_isdir.patch ./readlink-EINVAL.patch ./no-gets.patch ];

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
