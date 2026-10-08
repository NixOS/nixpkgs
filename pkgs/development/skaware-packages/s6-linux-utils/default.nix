{
  lib,
  skawarePackages,
  skalibs,
  execline,
}:

skawarePackages.buildPackage {
  pname = "s6-linux-utils";
  version = "2.6.4.1";
  sha256 = "sha256-FuGltaK0qYZ0tKlxlhKtt5WI48IMQIM2AnjqOPLTISk=";

  meta.description = "Set of minimalistic Linux-specific system utilities";
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
  ];

  # TODO: nsss support
  configureFlags = [
    "--libdir=${placeholder "out"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "out"}/libexec"
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable) fstab2s6rc rngseed
    rm libs6ps.a.xyzzy

    mv doc $doc/share/doc/s6-linux-utils/html
  '';

}
