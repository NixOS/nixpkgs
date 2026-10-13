{ skawarePackages, skalibs }:

skawarePackages.buildPackage {
  pname = "utmps";
  version = "0.1.3.4";
  sha256 = "sha256-EtzBAq1qyB+BrsxJUHM9uU81CBlHBUubFHPKxckIELw=";

  meta.description = "Secure utmpx and wtmp implementation";

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
    # remove all execline executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libutmps.*

    mv doc $doc/share/doc/utmps/html
    mv examples $doc/share/doc/utmps/examples
  '';
}
