{ stdenv

# Build time
, fetchurl, fetchpatch, pkgconfig, perl, texinfo, setupDebugInfoDirs, buildPackages

# Run time
, ncurses, readline, gmp, mpfr, expat, zlib, dejagnu

, pythonSupport ? stdenv.hostPlatform == stdenv.buildPlatform && !stdenv.hostPlatform.isCygwin, python3 ? null
, guile ? null

}:

let
  basename = "gdb-${version}";
  version = "8.2.1";
in

assert pythonSupport -> python3 != null;

stdenv.mkDerivation rec {
  name =
    stdenv.lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform)
                              (stdenv.targetPlatform.config + "-")
    + basename;

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}.tar.xz";
    sha256 = "00i27xqawjv282a07i73lp1l02n0a3ywzhykma75qg500wll6sha";
  };

  patches = [
    ./debug-info-from-env.patch
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    ./darwin-target-match.patch
    (fetchpatch {
      name = "gdb-aarch64-linux-tdep.patch";
      url = "https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=patch;h=0c0a40e0abb9f1a584330a1911ad06b3686e5361";
      excludes = [ "gdb/ChangeLog" ];
      sha256 = "16zjw99npyapj68sw52xzmbw671ajm9xv7g5jxfmp94if5y91mnj";
    })
  ];

  nativeBuildInputs = [ pkgconfig texinfo perl setupDebugInfoDirs ];

  buildInputs = [ ncurses readline gmp mpfr expat zlib guile ]
    ++ stdenv.lib.optional pythonSupport python3
    ++ stdenv.lib.optional doCheck dejagnu;

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  enableParallelBuilding = true;

  # darwin build fails with format hardening since v7.12
  hardeningDisable = stdenv.lib.optionals stdenv.isDarwin [ "format" ];

  NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ] ++ stdenv.lib.optional (stdenv.targetPlatform != stdenv.hostPlatform) "target";

  configureFlags = with stdenv.lib; [
    "--enable-targets=all" "--enable-64-bit-bfd"
    "--disable-install-libbfd"
    "--disable-shared" "--enable-static"
    "--with-system-zlib"
    "--with-system-readline"

    "--with-gmp=${gmp.dev}"
    "--with-mpfr=${mpfr.dev}"
    "--with-expat" "--with-libexpat-prefix=${expat.dev}"
  ] ++ stdenv.lib.optional (!pythonSupport) "--without-python";

  postInstall =
    '' # Remove Info files already provided by Binutils and other packages.
       rm -v $out/share/info/bfd.info
    '';

  # TODO: Investigate & fix the test failures.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "The GNU Project debugger";

    longDescription = ''
      GDB, the GNU Project debugger, allows you to see what is going
      on `inside' another program while it executes -- or what another
      program was doing at the moment it crashed.
    '';

    homepage = https://www.gnu.org/software/gdb/;

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = with platforms; linux ++ cygwin ++ darwin;
    maintainers = with maintainers; [ pierron ];
  };
}
