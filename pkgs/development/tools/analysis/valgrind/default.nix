{ stdenv, fetchurl, perl, gdb }:

stdenv.mkDerivation {
  name = "valgrind-3.4.0";

  src = fetchurl {
    url = http://valgrind.org/downloads/valgrind-3.4.0.tar.bz2;
    sha256 = "0x4zbwk9ml3kbjzwh887ahw0pdxcm5h9159qg9kwm7zgn7jlmsnm";
  };

  # Perl is needed for `cg_annotate'.
  # GDB is needed to provide a sane default for `--db-command'.
  buildInputs = [ perl gdb ];

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
  };
}
