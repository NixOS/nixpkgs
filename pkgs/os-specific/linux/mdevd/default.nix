{ lib, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "mdevd";
  version = "0.1.5.0";
  sha256 = "01ykxgnbm53wijdrbld10664xy2wkvyzbbs98mfnqnf4h1y064n0";

  description = "mdev-compatible Linux hotplug manager daemon";
  platforms = lib.platforms.linux;

  outputs = [ "bin" "out" "dev" "doc" ];

  configureFlags = [
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    # remove all mdevd executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)

    mv doc $doc/share/doc/mdevd/html
    mv examples $doc/share/doc/mdevd/examples
  '';
}
