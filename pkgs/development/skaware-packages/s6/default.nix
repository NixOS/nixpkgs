{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6";
  version = "2.11.3.2";
  sha256 = "fBYTitLw/74O0q6N0M7K2p98eH7dM6aQhNIZEQaT33Q=";

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
    rm ./libs6auto.a.xyzzy
    rm ./libs6lockd.a.xyzzy

    mv doc $doc/share/doc/s6/html
    mv examples $doc/share/doc/s6/examples
  '';

}
