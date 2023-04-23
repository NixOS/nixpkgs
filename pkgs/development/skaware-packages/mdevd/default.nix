{ lib, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "mdevd";
  version = "0.1.6.2";
  sha256 = "rC/PkATweQRZLFiU4sQB4VuwJ+zze8uOpmHip5k0R74=";

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
    rm libmdevd.*

    mv doc $doc/share/doc/mdevd/html
    mv examples $doc/share/doc/mdevd/examples
  '';
}
