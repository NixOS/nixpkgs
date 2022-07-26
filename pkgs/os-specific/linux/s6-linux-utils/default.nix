{ lib, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6-linux-utils";
  version = "2.6.0.0";
  sha256 = "sha256-bHEyc0oMgocALuaRDEafF1qX12aoAjwMM6+LqSZD7Vk=";

  description = "A set of minimalistic Linux-specific system utilities";
  platforms = lib.platforms.linux;

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
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable) rngseed

    mv doc $doc/share/doc/s6-linux-utils/html
  '';

}
