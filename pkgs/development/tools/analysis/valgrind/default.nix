{ stdenv, fetchurl, perl, gdb }:

stdenv.mkDerivation {
  name = "valgrind-3.3.1";

  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.3.1.tar.bz2;
    sha256 = "1ymai2xr3c7132vzkngrshlcsrs1qagfd4vwccr96ixx2pcb9dwm";
  };

  patches = [ ./callgrind_annotate.patch ];

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
