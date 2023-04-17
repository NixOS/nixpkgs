{ lib, skawarePackages

# Whether to build the TLS/SSL tools and what library to use
# acceptable values: "bearssl", "libressl", false
, sslSupport ? "bearssl" , libressl, bearssl
}:

with skawarePackages;
let
  sslSupportEnabled = sslSupport != false;
  sslLibs = {
    libressl = libressl;
    bearssl = bearssl;
  };

in
assert sslSupportEnabled -> sslLibs ? ${sslSupport};


buildPackage {
  pname = "s6-networking";
  version = "2.5.1.3";
  sha256 = "oJ5DyVn/ngyqj/QAJgjnPA9X+H8EqNnCTmya/v5F6Xc=";

  description = "A suite of small networking utilities for Unix systems";

  outputs = [ "bin" "lib" "dev" "doc" "out" ];

  # TODO: nsss support
  configureFlags = [
    "--libdir=\${lib}/lib"
    "--libexecdir=\${lib}/libexec"
    "--dynlibdir=\${lib}/lib"
    "--bindir=\${bin}/bin"
    "--includedir=\${lib.getDev dev}/include"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
    "--with-include=${lib.getDev skalibs}/include"
    "--with-include=${lib.getDev execline}/include"
    "--with-include=${lib.getDev s6}/include"
    "--with-include=${lib.getDev s6-dns}/include"
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
       "--with-include=${lib.getDev sslLibs.${lib.getDev sslSupport}}/include"
       "--with-lib=${lib.getLib sslLibs.${sslSupport}}/lib"
       "--with-dynlib=${lib.getLib sslLibs.${sslSupport}}/lib"
     ]);

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable)
    rm libs6net.* libstls.* libs6tls.* libsbearssl.*

    mv doc $doc/share/doc/s6-networking/html
  '';

}
