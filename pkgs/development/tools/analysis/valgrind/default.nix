{ stdenv, fetchurl, perl, gdb, autoconf, automake }:

stdenv.mkDerivation rec {
  name = "valgrind-3.5.0";

  src = fetchurl {
    url = "http://valgrind.org/downloads/${name}.tar.bz2";
    sha256 = "105s4y6h5rsfvml1dfhsjvqgsxvnclbnxbpgk8b4ghpbpcr52fkl";
  };

  # Make Valgrind compile with Glibc 2.12.
  patches = [ ./glibc-2.12.patch ];
  patchFlags = "-p0";
  preConfigure = "autoreconf";

  # Perl is needed for `cg_annotate'.
  # GDB is needed to provide a sane default for `--db-command'.
  buildInputs = [ perl autoconf automake ] ++ stdenv.lib.optional (!stdenv.isDarwin) gdb;

  configureFlags =
    if stdenv.system == "x86_64-linux" then ["--enable-only64bit"] else [];

  postInstall = ''
    for i in $out/lib/valgrind/*.supp; do
      substituteInPlace $i \
        --replace 'obj:/lib' 'obj:*/lib' \
        --replace 'obj:/usr/X11R6/lib' 'obj:*/lib' \
        --replace 'obj:/usr/lib' 'obj:*/lib'
    done
  '';

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

    maintainers = [ stdenv.lib.maintainers.eelco ];
    
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
