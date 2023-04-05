{ lib, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "mdevd";
  version = "0.1.6.1";
  sha256 = "XAHk55QW22zZk++KkBRii48fC2xkMnWYhIhRL6pUBLE=";

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
