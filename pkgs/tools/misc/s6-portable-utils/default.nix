{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6-portable-utils";
  version = "2.2.5.0";
  sha256 = "sha256-67OfiTT9NvJdMTUuYbvZTcArHp8EQRhQ0v2WWL2RbjY=";

  description = "A set of tiny general Unix utilities optimized for simplicity and small size";

  outputs = [ "bin" "dev" "doc" "out" ];

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
    rm seekablepipe

    mv doc $doc/share/doc/s6-portable-utils/html
  '';


}
