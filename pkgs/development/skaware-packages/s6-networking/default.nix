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
  version = "2.8.0.1";
  sha256 = "sha256-bwEcM7oFhs5Y/u4M+FSgsIfpCC/b0kq7eGFIRjgw80E=";

  manpages = skawarePackages.buildManPages {
    pname = "s6-networking-man-pages";
    version = "2.7.2.1.4";
    sha256 = "sha256-N5BXi21JEgF3X5FKg5SzKNKfzYS5uTRqbUvbsrEZ2xg=";
    description = "Port of the documentation for the s6-networking suite to mdoc";
    maintainers = [ lib.maintainers.sternenseemann ];
  };

  meta.description = "Suite of small networking utilities for Unix systems";

  outputs = [
    "bin"
    "lib"
    "dev"
    "doc"
    "out"
  ];
  buildInputs = [
    skalibs
    execline
    s6
    s6-dns
  ]
  ++ lib.optional sslSupportEnabled sslLibs.${sslSupport};

  # TODO: nsss support
  configureFlags = [
    "--libdir=${placeholder "lib"}/lib"
    "--dynlibdir=${placeholder "out"}/lib"
    "--libexecdir=${placeholder "lib"}/libexec"
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--pkgconfdir=${placeholder "dev"}/lib/pkgconfig"
    "--with-sysdeps=${skalibs.lib}/lib/skalibs/sysdeps"
  ]
  ++ lib.optional sslSupportEnabled "--enable-ssl=${sslSupport}";

  postInstall = ''
    # remove all s6 executables from build directory
    rm $(find -name "s6-*" -type f -mindepth 1 -maxdepth 1 -executable) proxy-server
    rm libs6net.* libstls.* libs6tls.* libsbearssl.*

    mv doc $doc/share/doc/s6-networking/html
  '';

}
