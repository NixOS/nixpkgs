{ skawarePackages, skalibs }:

skawarePackages.buildPackage {
  pname = "s6-dns";
  version = "2.4.1.3";
  sha256 = "sha256-+enetGSMVQeoSFVINkvRxW2r2jlLye4tfxy7FqA2zXY=";

  meta.description = "Suite of DNS client programs and libraries for Unix systems";

  outputs = [
    "bin"
    "lib"
    "dev"
    "doc"
    "out"
  ];

  buildInputs = [ skalibs ];

  configureFlags = [
    "--libdir=${placeholder "lib"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "lib"}/libexec"
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
  ];

  postInstall = ''
    # remove all s6-dns executables from build directory
    rm $(find -type f -mindepth 1 -maxdepth 1 -executable)
    rm libs6dns.*
    rm libskadns.*

    mv doc $doc/share/doc/s6-dns/html
  '';

}
