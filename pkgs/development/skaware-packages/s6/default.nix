{
  lib,
  skawarePackages,
  skalibs,
  execline,
}:

skawarePackages.buildPackage {
  pname = "s6";
  version = "2.13.0.0";
  sha256 = "fkb49V2Auw4gJaZNXWSa9KSsIeNIAgyqrd4wul5bSDA=";

  manpages = skawarePackages.buildManPages {
    pname = "s6-man-pages";
    version = "2.13.0.0.1";
    sha256 = "oZgyJ2mPxpgsV2Le29XM+NsjMhqvDQ70SUZ2gjYg5U8=";
    description = "Port of the documentation for the s6 supervision suite to mdoc";
    maintainers = [ lib.maintainers.sternenseemann ];
  };

  description = "skarnet.org's small & secure supervision software suite";

  # NOTE lib: cannot split lib from bin at the moment,
  # since some parts of lib depend on executables in bin.
  # (the `*_startf` functions in `libs6`)
  outputs = [
    # "bin" "lib"
    "out"
    "dev"
    "doc"
  ];

  # TODO: nsss support
  configureFlags = [
    "--libdir=\${out}/lib"
    "--libexecdir=\${out}/libexec"
    "--dynlibdir=\${out}/lib"
    "--bindir=\${out}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-include=${execline.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libs6.*
    rm ./libs6auto.a.xyzzy

    mv doc $doc/share/doc/s6/html
    mv examples $doc/share/doc/s6/examples
  '';

}
