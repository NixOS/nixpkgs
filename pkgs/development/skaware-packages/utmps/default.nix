{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "utmps";
  version = "0.1.2.1";
  sha256 = "BCPfx0vxOQ5G4uDCECIbsgX8247yMn5x7QhQd3xdyb0=";

  description = "A secure utmpx and wtmp implementation";

  configureFlags = [
    "--libdir=\${lib}/lib"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    # remove all execline executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libutmps.*

    mv doc $doc/share/doc/utmps/html
    mv examples $doc/share/doc/utmps/examples
  '';
}
