{ stdenv, fetchurl, perl, gdb, llvm, cctools, xnu, bootstrap_cmds, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "valgrind-3.14.0";

  src = fetchurl {
    url = "https://sourceware.org/pub/valgrind/${name}.tar.bz2";
    sha256 = "19ds42jwd89zrsjb94g7gizkkzipn8xik3xykrpcqxylxyzi2z03";
  };

  # autoreconfHook is needed to pick up patching of Makefile.am
  # Remove when the patch no longer applies.
  patches = [ ./coregrind-makefile-race.patch ];
  # Perl is needed for `cg_annotate'.
  nativeBuildInputs = [ autoreconfHook perl ];

  outputs = [ "out" "dev" "man" "doc" ];

  hardeningDisable = [ "stackprotector" ];

  # GDB is needed to provide a sane default for `--db-command'.
  buildInputs = [ gdb ]  ++ stdenv.lib.optionals (stdenv.isDarwin) [ bootstrap_cmds xnu ];

  enableParallelBuilding = true;
  separateDebugInfo = stdenv.isLinux;

  preConfigure = stdenv.lib.optionalString stdenv.isDarwin (
    let OSRELEASE = ''
      $(awk -F '"' '/#define OSRELEASE/{ print $2 }' \
      <${xnu}/Library/Frameworks/Kernel.framework/Headers/libkern/version.h)'';
    in ''
      echo "Don't derive our xnu version using uname -r."
      substituteInPlace configure --replace "uname -r" "echo ${OSRELEASE}"

      # Apple's GCC doesn't recognize `-arch' (as of version 4.2.1, build 5666).
      echo "getting rid of the \`-arch' GCC option..."
      find -name Makefile\* -exec \
        sed -i {} -e's/DARWIN\(.*\)-arch [^ ]\+/DARWIN\1/g' \;

      sed -i coregrind/link_tool_exe_darwin.in \
          -e 's/^my \$archstr = .*/my $archstr = "x86_64";/g'

      echo "substitute hardcoded /usr/include/mach with ${xnu}/include/mach"
      substituteInPlace coregrind/Makefile.in \
         --replace /usr/include/mach ${xnu}/include/mach

      echo "substitute hardcoded dsymutil with ${llvm}/bin/llvm-dsymutil"
      find -name "Makefile.in" | while read file; do
         substituteInPlace "$file" \
           --replace dsymutil ${llvm}/bin/llvm-dsymutil
      done

      substituteInPlace coregrind/m_debuginfo/readmacho.c \
         --replace /usr/bin/dsymutil ${llvm}/bin/llvm-dsymutil

      echo "substitute hardcoded /usr/bin/ld with ${cctools}/bin/ld"
      substituteInPlace coregrind/link_tool_exe_darwin.in \
        --replace /usr/bin/ld ${cctools}/bin/ld
    '');

  # To prevent rebuild on linux when moving darwin's postPatch fixes to preConfigure
  postPatch = "";

  configureFlags =
    stdenv.lib.optional (stdenv.hostPlatform.system == "x86_64-linux" || stdenv.hostPlatform.system == "x86_64-darwin") "--enable-only64bit";

  doCheck = false; # fails

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
    description = "Debugging and profiling tool suite";

    longDescription = ''
      Valgrind is an award-winning instrumentation framework for
      building dynamic analysis tools.  There are Valgrind tools that
      can automatically detect many memory management and threading
      bugs, and profile your programs in detail.  You can also use
      Valgrind to build new tools.
    '';

    license = stdenv.lib.licenses.gpl2Plus;

    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.unix;
  };
}
