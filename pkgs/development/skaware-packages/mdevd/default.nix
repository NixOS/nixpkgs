{
  lib,
  skawarePackages,
  skalibs,
}:

skawarePackages.buildPackage {
  pname = "mdevd";
  version = "0.1.7.0";
  sha256 = "sha256-7JZu7DmHnzPHhTQzcwIcRPiHyDagj8rx1jQS472/yjI=";

  description = "mdev-compatible Linux hotplug manager daemon";
  platforms = lib.platforms.linux;

  outputs = [
    "bin"
    "out"
    "dev"
    "doc"
  ];

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
