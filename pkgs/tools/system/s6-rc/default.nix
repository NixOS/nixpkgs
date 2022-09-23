{ lib, stdenv, skawarePackages, targetPackages }:

with skawarePackages;

buildPackage {
  pname = "s6-rc";
  version = "0.5.3.2";
  sha256 = "sha256-TySklmpKo1PSvRqK/Km4jHt70pxGs6Gn9TBWhrnW4Dg=";

  description = "A service manager for s6-based systems";
  platforms = lib.platforms.unix;

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  configureFlags = [
    "--libdir=\${lib}/lib"
    "--libexecdir=\${lib}/libexec"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-include=${execline.dev}/include"
    "--with-include=${s6.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-lib=${s6.out}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
    "--with-dynlib=${s6.out}/lib"
  ];

  # s6-rc-compile generates built-in service definitions containing
  # absolute paths to execline, s6, and s6-rc programs.  If we're
  # running s6-rc-compile as part of a Nix derivation, and we want to
  # cross-compile that derivation, those paths will be wrong --
  # they'll be for execline, s6, and s6-rc on the platform we're
  # running s6-rc-compile on, not the platform we're targeting.
  #
  # We can detect this special case of s6-rc being used at build time
  # in a derivation that's being cross-compiled, because that's the
  # only time hostPlatform != targetPlatform.  When that happens we
  # modify s6-rc-compile to use the configuration headers for the
  # system we're cross-compiling for.
  postConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.targetPlatform) ''
    substituteInPlace src/s6-rc/s6-rc-compile.c \
        --replace '<execline/config.h>' '"${targetPackages.execline.dev}/include/execline/config.h"' \
        --replace '<s6/config.h>' '"${targetPackages.s6.dev}/include/s6/config.h"' \
        --replace '<s6-rc/config.h>' '"${targetPackages.s6-rc.dev}/include/s6-rc/config.h"'
  '';

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-rc-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm s6-rc libs6rc.*

    mv doc $doc/share/doc/s6-rc/html
    mv examples $doc/share/doc/s6-rc/examples
  '';

}
