{
  lib,
  skawarePackages,
  skalibs,
}:

skawarePackages.buildPackage {
  pname = "utmps";
  version = "0.1.3.1";
  sha256 = "sha256-HEwTerNm9txrgdOlcsmXUUtk14S9Uuf5UU5vbz8chbk=";

  description = "Secure utmpx and wtmp implementation";

  configureFlags = [
    "--libdir=\${lib}/lib"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${lib.getLib skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${lib.getLib skalibs}/lib"
    "--with-dynlib=${lib.getLib skalibs}/lib"
  ];

  postInstall = ''
    # remove all execline executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libutmps.*

    mv doc $doc/share/doc/utmps/html
    mv examples $doc/share/doc/utmps/examples
  '';
}
