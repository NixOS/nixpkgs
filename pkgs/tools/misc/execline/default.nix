{ stdenv, skawarePackages, makeWrapper }:

with skawarePackages;

buildPackage {
  pname = "execline";
  version = "2.5.0.1";
  sha256 = "0j8hwdw8wn0rv8njdza8fbgmvyjg7hqp3qlbw00i7fwskr7d21wd";

  description = "A small scripting language, to be used in place of a shell in non-interactive scripts";

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  setupHooks = [ makeWrapper ];

  # TODO: nsss support
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
    rm libexecline.*

    mv doc $doc/share/doc/execline/html
    mv examples $doc/share/doc/execline/examples

    # finally, add all tools to PATH so they are available
    # from within execlineb scripts by default
    wrapProgram $bin/bin/execlineb \
      --suffix PATH : $bin/bin
  '';

}
