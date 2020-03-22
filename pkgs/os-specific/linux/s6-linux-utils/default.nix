{ stdenv, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6-linux-utils";
  version = "2.5.1.2";
  sha256 = "0w4jms9qyb5kx9zcyd3gzri60rrii2rbmh08s59ckg4awy27py86";

  description = "A set of minimalistic Linux-specific system utilities";
  platforms = stdenv.lib.platforms.linux;

  outputs = [ "bin" "dev" "doc" "out" ];

  # TODO: nsss support
  configureFlags = [
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable)

    mv doc $doc/share/doc/s6-linux-utils/html
  '';

}
