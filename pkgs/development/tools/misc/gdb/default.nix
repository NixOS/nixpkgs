{ stdenv

# Build time
, fetchurl, pkgconfig, perl, texinfo, setupDebugInfoDirs

# Run time
, ncurses, readline, gmp, mpfr, expat, zlib, dejagnu

, buildPlatform, hostPlatform, targetPlatform

, pythonSupport ? hostPlatform == buildPlatform && !hostPlatform.isCygwin, python ? null
, guile ? null

# Additional dependencies for GNU/Hurd.
, mig ? null, hurd ? null

}:

let
  basename = "gdb-${version}";
  version = "8.0.1";
in

assert targetPlatform.isHurd -> mig != null && hurd != null;
assert pythonSupport -> python != null;

stdenv.mkDerivation rec {
  name =
    stdenv.lib.optionalString (targetPlatform != hostPlatform)
                              (targetPlatform.config + "-")
    + basename;

  src = fetchurl {
    url = "mirror://gnu/gdb/${basename}.tar.xz";
    sha256 = "1qwmcbaxf0jc7yjl0fimgcfj2yqcrl6h7azgs1d838kbwf9mzg9x";
  };

  patches = [ ./debug-info-from-env.patch ];

  nativeBuildInputs = [ pkgconfig texinfo perl setupDebugInfoDirs ]
    # TODO(@Ericson2314) not sure if should be host or target
    ++ stdenv.lib.optional targetPlatform.isHurd mig;

  buildInputs = [ ncurses readline gmp mpfr expat zlib guile ]
    ++ stdenv.lib.optional pythonSupport python
    ++ stdenv.lib.optional targetPlatform.isHurd hurd
    ++ stdenv.lib.optional doCheck dejagnu;

  propagatedNativeBuildInputs = [ setupDebugInfoDirs ];

  enableParallelBuilding = true;

  # darwin build fails with format hardening since v7.12
  hardeningDisable = stdenv.lib.optionals stdenv.isDarwin [ "format" ];

  NIX_CFLAGS_COMPILE = "-Wno-format-nonliteral";

  # TODO(@Ericson2314): Always pass "--target" and always prefix.
  configurePlatforms = [ "build" "host" ] ++ stdenv.lib.optional (targetPlatform != hostPlatform) "target";

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

    homepage = http://www.gnu.org/software/gdb/;

    license = stdenv.lib.licenses.gpl3Plus;

    platforms = with platforms; linux ++ cygwin ++ darwin;
    maintainers = with maintainers; [ pierron ];
  };
}
