{
  lib,
  skawarePackages,
  skalibs,
  execline,
}:

skawarePackages.buildPackage {
  pname = "s6-linux-utils";
  version = "2.6.4.0";
  sha256 = "sha256-zHJ/cNXoeAQzpJest8sxAGVrMSZYmrAunSBCAGx5TPI=";

  description = "Set of minimalistic Linux-specific system utilities";
  platforms = lib.platforms.linux;

  outputs = [
    "bin"
    "dev"
    "doc"
    "out"
  ];

  # TODO: nsss support
  configureFlags = [
    "--bindir=\${bin}/bin"
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
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable) fstab2s6rc rngseed
    rm libs6ps.a.xyzzy

    mv doc $doc/share/doc/s6-linux-utils/html
  '';

}
