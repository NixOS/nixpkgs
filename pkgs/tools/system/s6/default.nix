{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6";
  version = "2.9.0.1";
  sha256 = "0mvcjrz8nlj9p2zclmcv22b4y6bqzd2iz38arhgc989vdvrbmkg0";

  description = "skarnet.org's small & secure supervision software suite";

  # NOTE lib: cannot split lib from bin at the moment,
  # since some parts of lib depend on executables in bin.
  # (the `*_startf` functions in `libs6`)
  outputs = [ /*"bin" "lib"*/ "out" "dev" "doc" ];

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

    mv doc $doc/share/doc/s6/html
    mv examples $doc/share/doc/s6/examples
  '';

}
