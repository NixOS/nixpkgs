{ stdenv, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6-linux-utils";
  version = "2.5.0.1";
  sha256 = "0bpcaah3rbz4i013bkarr7wxmfvisjyxg0z78xg5zfbgajpgjxx1";

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
