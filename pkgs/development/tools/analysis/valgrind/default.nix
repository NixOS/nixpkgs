{ stdenv, fetchurl, perl, gdb }:

stdenv.mkDerivation {
  name = "valgrind-3.3.0";

  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.3.0.tar.bz2;
    sha256 = "0yllx5a2f5bx18gqz74aikr27zxwpblswn65lqvm9rbzswlq5w2s";
  };

  # Perl is needed for `cg_annotate'.
  # GDB is needed to provide a sane default for `--db-command'.
  buildInputs = [ perl gdb ];

  configureFlags =
    if stdenv.system == "x86_64-linux" then ["--enable-only64bit"] else [];

  meta = {
    homepage = http://www.valgrind.org/;
    description = "Valgrind, a debugging and profiling tool suite";

    longDescription = ''
      Valgrind is an award-winning instrumentation framework for
      building dynamic analysis tools.  There are Valgrind tools that
      can automatically detect many memory management and threading
      bugs, and profile your programs in detail.  You can also use
      Valgrind to build new tools.
    '';

    license = "GPLv2+";
  };
}
