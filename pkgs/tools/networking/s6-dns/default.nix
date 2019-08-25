{ skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6-dns";
  version = "2.3.0.2";
  sha256 = "1y9bhvx8bqsb2xq5lmlfnc1hw2b3jyqg11i9r4lj0n6vvaqwh1j8";

  description = "A suite of DNS client programs and libraries for Unix systems";

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  configureFlags = [
    "--libdir=\${lib}/lib"
    "--libexecdir=\${lib}/libexec"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
  ];

  postInstall = ''
    # remove all s6-dns executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libs6dns.*
    rm libskadns.*

    mv doc $doc/share/doc/s6-dns/html
  '';

}
