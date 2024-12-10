{
  lib,
  skawarePackages,
  skalibs,
  execline,
  s6,
  s6-dns,

  # Whether to build the TLS/SSL tools and what library to use
  # acceptable values: "bearssl", "libressl", false
  sslSupport ? "bearssl",
  libressl,
  bearssl,
}:

let
  sslSupportEnabled = sslSupport != false;
  sslLibs = {
    libressl = libressl;
    bearssl = bearssl;
  };

in
assert sslSupportEnabled -> sslLibs ? ${sslSupport};

skawarePackages.buildPackage {
  pname = "s6-networking";
  version = "2.7.0.2";
  sha256 = "wzxvGyvhb4miGvlGz9BiQqEvmBhMiYt1XdskM4ZxzrE=";

  manpages = skawarePackages.buildManPages {
    pname = "s6-networking-man-pages";
    version = "2.5.1.3.3";
    sha256 = "02ba5jyfpbib402mfl42pbbdxyjy2vhpiz1b2qdg4ax58yr4jzqk";
    description = "Port of the documentation for the s6-networking suite to mdoc";
    maintainers = [ lib.maintainers.sternenseemann ];
  };

  description = "A suite of small networking utilities for Unix systems";

  outputs = [
    "bin"
    "lib"
    "dev"
    "doc"
    "out"
  ];

  # TODO: nsss support
  configureFlags =
    [
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
    rm libs6net.* libstls.* libs6tls.* libsbearssl.*

    mv doc $doc/share/doc/s6-networking/html
  '';

}
