{ stdenv, skawarePackages

# Whether to build the TLS/SSL tools and what library to use
# acceptable values: "libressl", false
# TODO: add bearssl
, sslSupport ? "libressl" , libressl
}:

with skawarePackages;
let
  inherit (stdenv) lib;
  sslSupportEnabled = sslSupport != false;
  sslLibs = {
    libressl = libressl;
  };

in
assert sslSupportEnabled -> sslLibs ? ${sslSupport};


buildPackage {
  pname = "s6-networking";
  version = "2.3.1.1";
  sha256 = "127i7ig5wdgjbkjf0py0g96llc6cbxij22ns2j7bwa95figinhcx";

  description = "A suite of small networking utilities for Unix systems";

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  # TODO: nsss support
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
    "--with-include=${s6-dns.dev}/include"
    "--with-lib=${skalibs.lib}/lib"
    "--with-lib=${execline.lib}/lib"
    "--with-lib=${s6.out}/lib"
    "--with-lib=${s6-dns.lib}/lib"
    "--with-dynlib=${skalibs.lib}/lib"
    "--with-dynlib=${execline.lib}/lib"
    "--with-dynlib=${s6.out}/lib"
    "--with-dynlib=${s6-dns.lib}/lib"
  ]
  ++ (lib.optionals sslSupportEnabled [
       "--enable-ssl=${sslSupport}"
       "--with-include=${lib.getDev sslLibs.${sslSupport}}/include"
       "--with-lib=${lib.getLib sslLibs.${sslSupport}}/lib"
       "--with-dynlib=${lib.getLib sslLibs.${sslSupport}}/lib"
     ]);

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm minidentd
    rm libs6net.* libstls.*

    mv doc $doc/share/doc/s6-networking/html
  '';

}
