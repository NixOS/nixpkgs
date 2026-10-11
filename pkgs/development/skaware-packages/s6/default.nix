{
  lib,
  skawarePackages,
  skalibs,
  execline,
}:

skawarePackages.buildPackage {
  pname = "s6";
  version = "2.15.1.0";
  sha256 = "sha256-6rnEbiK2axYTX5oF7Gig6ih9kGC4TRDe+qosqtFYq1I=";

  manpages = skawarePackages.buildManPages {
    pname = "s6-man-pages";
    version = "2.14.0.1.4";
    sha256 = "sha256-c77NwS4x5L1nLmtWVz64izzanTfc0hohvFMOi77uMh4=";
    description = "Port of the documentation for the s6 supervision suite to mdoc";
    maintainers = [ lib.maintainers.sternenseemann ];
  };

  meta.description = "skarnet.org's small & secure supervision software suite";

  # NOTE lib: cannot split lib from bin at the moment,
  # since some parts of lib depend on executables in bin.
  # (the `*_startf` functions in `libs6`)
  outputs = [
    # "bin" "lib"
    "out"
    "dev"
    "doc"
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
    "--bindir=${placeholder "out"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
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
