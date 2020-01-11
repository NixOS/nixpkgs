{ stdenv, skawarePackages }:

with skawarePackages;

buildPackage {
  pname = "s6-rc";
  version = "0.5.1.1";
  sha256 = "0lmg517l8inn7bi57q35rjd7b4jmqlmkhrbvs5ybbhinhd12qzi5";

  description = "A service manager for s6-based systems";
  platforms = stdenv.lib.platforms.linux;

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  configureFlags = [
    "--libdir=\${lib}/lib"
    "--libexecdir=\${lib}/libexec"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${skalibs.dev}/include"
    "--with-include=${execline.dev}/include"
    "--with-include=${s6.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-lib=${s6.out}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
    "--with-dynlib=${s6.out}/lib"
  ];

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-rc-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm s6-rc libs6rc.*

    mv doc $doc/share/doc/s6-rc/html
    mv examples $doc/share/doc/s6-rc/examples
  '';

}
