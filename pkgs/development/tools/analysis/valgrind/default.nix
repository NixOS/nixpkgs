{ stdenv, fetchurl, perl, gdb }:

stdenv.mkDerivation (rec {
  name = "valgrind-3.7.0";

  src = fetchurl {
    url = "http://valgrind.org/downloads/${name}.tar.bz2";
    sha256 = "1xnb4jiimscwriw3jd1lkk0m9x4glqpijj9jb4ngx08l1wrw0qjx";
  };

  # Perl is needed for `cg_annotate'.
  # GDB is needed to provide a sane default for `--db-command'.
  buildNativeInputs = [ perl ];
  buildInputs = stdenv.lib.optional (!stdenv.isDarwin) gdb;

  configureFlags =
    if (stdenv.system == "x86_64-linux" || stdenv.system == "x86_64-darwin")
    then [ "--enable-only64bit" ]
    else [];

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

    maintainers = with stdenv.lib.maintainers; [ eelco ludo ];
    platforms = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}

//

(if stdenv.isDarwin
 then {
   patchPhase =
     # Apple's GCC doesn't recognize `-arch' (as of version 4.2.1, build 5666).
     '' echo "getting rid of the \`-arch' GCC option..."
        find -name Makefile\* -exec \
          sed -i {} -e's/DARWIN\(.*\)-arch [^ ]\+/DARWIN\1/g' \;

        sed -i coregrind/link_tool_exe_darwin.in \
            -e 's/^my \$archstr = .*/my $archstr = "x86_64";/g'
     '';

   preConfigure =
     # Shamelessly drag in MIG.
     '' mkdir -p "$TMPDIR/impure-deps/bin"

        # MIG assumes the standard Darwin core utilities (e.g., `rm -d'), so
        # let it see the impure directories.
        cat > "$TMPDIR/impure-deps/bin/mig" <<EOF
#!/bin/sh
export PATH="/usr/bin:/bin:\$PATH"
exec /usr/bin/mig "\$@"
EOF
        chmod +x "$TMPDIR/impure-deps/bin/mig"

        export PATH="$TMPDIR/impure-deps/bin:$PATH"
     '';
 }
 else {}))
