{ fetchurl, stdenv, ncurses, readline, gmp, mpfr, expat, texinfo, zlib
, dejagnu, perl, pkgconfig

, buildPlatform, hostPlatform, targetPlatform

, pythonSupport ? hostPlatform == buildPlatform && !hostPlatform.isCygwin, python ? null
, guile ? null

# Support all known targets in one gdb binary.
, multitarget ? false

# Additional dependencies for GNU/Hurd.
, mig ? null, hurd ? null
}:

let
  basename = "gdb-${version}";
  version = "7.12.1";
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
    sha256 = "11ii260h1sd7v0bs3cz6d5l8gqxxgldry0md60ncjgixjw5nh1s6";
  };

  nativeBuildInputs = [ pkgconfig texinfo perl ]
    # TODO(@Ericson2314) not sure if should be host or target
    ++ stdenv.lib.optional targetPlatform.isHurd mig;

  buildInputs = [ ncurses readline gmp mpfr expat zlib guile ]
    ++ stdenv.lib.optional pythonSupport python
    ++ stdenv.lib.optional targetPlatform.isHurd hurd
    ++ stdenv.lib.optional doCheck dejagnu;

  enableParallelBuilding = true;

  # darwin build fails with format hardening since v7.12
  hardeningDisable = stdenv.lib.optionals stdenv.isDarwin [ "format" ];

  configureFlags = with stdenv.lib; [
    "--with-gmp=${gmp.dev}" "--with-mpfr=${mpfr.dev}" "--with-system-readline"
    "--with-system-zlib" "--with-expat" "--with-libexpat-prefix=${expat.dev}"
  ] ++ stdenv.lib.optional hostPlatform.isLinux
      # TODO(@Ericson2314): make this conditional on whether host platform is NixOS
      "--with-separate-debug-dir=/run/current-system/sw/lib/debug"
    ++ stdenv.lib.optional (!pythonSupport) "--without-python"
    # TODO(@Ericson2314): This should be done in stdenv, not per-package
    ++ stdenv.lib.optional (targetPlatform != hostPlatform) "--target=${targetPlatform.config}"
    ++ stdenv.lib.optional multitarget "--enable-targets=all";

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
