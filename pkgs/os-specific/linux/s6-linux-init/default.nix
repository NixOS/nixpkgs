{ lib, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6-linux-init";
  version = "1.0.6.2";
  sha256 = "06xcmn2a89fvng056lcnnyrl2ak0y7cblkc90lj9a2liyhawy9dr";

  description = "A set of minimalistic tools used to create a s6-based init system, including a /sbin/init binary, on a Linux kernel";
  platforms = lib.platforms.linux;

  outputs = [ "bin" "dev" "doc" "out" ];

  configureFlags = [
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-include=${execline.dev}/include"
    "--with-include=${s6.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${s6.out}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
    "--with-dynlib=${s6.out}/lib"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm libs6_linux_init.* libhpr.*
    rm -rf skel

    mv doc $doc/share/doc/s6-linux-init/html
  '';

}
