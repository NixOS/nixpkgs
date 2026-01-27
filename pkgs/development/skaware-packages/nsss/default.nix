{
  lib,
  skawarePackages,
  skalibs,
  pkg-config,
}:

skawarePackages.buildPackage {
  pname = "nsss";
  version = "0.2.1.0";
  sha256 = "sha256-8iGjHBzuiB6ZKobf4pYzIlPHqfxl9g2IgpzI6JSEIPQ=";

  description = "Implementation of a subset of the pwd.h, group.h and shadow.h family of functions";

  nativeBuildInputs = [
    pkg-config
  ];

  propagatedBuildInputs = [
    skalibs
  ];

  outputs = [
    "bin"
    "dev"
    "doc"
    "out"
  ];

  # TODO: nsss support
  configureFlags = [
    "--with-sysdeps=${lib.getLib skalibs}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${lib.getLib skalibs}/lib"
    "--with-dynlib=${lib.getLib skalibs}/lib"
    "--with-pkgconfig"
    "--enable-pkgconfig"
  ];

  postInstall = ''
    # remove all nsss executables from build directory
    rm $(find -name "nsssd-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm libnsss.* libnsssd.*

    mv doc $doc/share/doc/nsss/html
    mv examples $doc/share/doc/nsss/examples
  '';

}
