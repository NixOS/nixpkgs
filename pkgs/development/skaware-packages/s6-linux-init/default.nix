{
  lib,
  stdenv,
  skawarePackages,
  skalibs,
  execline,
  s6,
  targetPackages,
}:

skawarePackages.buildPackage {
  pname = "s6-linux-init";
  version = "1.2.0.2";
  sha256 = "sha256-b60BTaFiwMgZJBl8V9FuGnXBM7NKIOQjQxobdB6Qex0=";

  meta.description = "Set of minimalistic tools used to create a s6-based init system, including a /sbin/init binary, on a Linux kernel";
  meta.platforms = lib.platforms.linux;

  outputs = [
    "bin"
    "dev"
    "doc"
    "out"
  ];
  buildInputs = [
    skalibs
    execline
    s6
  ];

  configureFlags = [
    "--libdir=${placeholder "out"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "out"}/libexec"
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
  ];

  # See ../s6-rc/default.nix for an explanation
  postConfigure = lib.optionalString (stdenv.hostPlatform != stdenv.targetPlatform) ''
    substituteInPlace src/init/s6-linux-init-maker.c \
        --replace-fail '<execline/config.h>' '"${targetPackages.execline.dev}/include/execline/config.h"' \
        --replace-fail '<s6/config.h>' '"${targetPackages.s6.dev}/include/s6/config.h"' \
        --replace-fail '<s6-linux-init/config.h>' '"${targetPackages.s6-linux-init.dev}/include/s6-linux-init/config.h"'
  '';

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm libs6_linux_init.* libhpr.*
    rm -rf skel

    mv doc $doc/share/doc/s6-linux-init/html
  '';

}
