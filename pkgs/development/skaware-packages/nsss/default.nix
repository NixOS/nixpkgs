{ skawarePackages, skalibs }:

skawarePackages.buildPackage {
  pname = "nsss";
  version = "0.2.1.3";
  sha256 = "sha256-FNpESoNtJLaihvrIilAr2qKWpNMo8J1Sl1aK07PgJoU=";

  meta.description = "Implementation of a subset of the pwd.h, group.h and shadow.h family of functions";

  buildInputs = [ skalibs ];

  configureFlags = [
    "--libdir=${placeholder "lib"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "lib"}/libexec"
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
  ];

  postInstall = ''
    # remove all nsss executables from build directory
    rm $(find -name "nsssd-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm libnsss.* libnsssd.*

    mv doc $doc/share/doc/nsss/html
    mv examples $doc/share/doc/nsss/examples
  '';

}
