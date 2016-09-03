{ stdenv, lib, fetchurl, pkgconfig
, curl, apacheHttpd, pcre, apr, aprutil, libxml2 }:

with lib;

stdenv.mkDerivation rec {
  name = "modsecurity-${version}";
  version = "2.9.0";

  src = fetchurl {
    url = "https://www.modsecurity.org/tarball/${version}/${name}.tar.gz";
    sha256 = "e2bbf789966c1f80094d88d9085a81bde082b2054f8e38e0db571ca49208f434";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ curl apacheHttpd pcre apr aprutil libxml2 ];
  configureFlags = [
    "--enable-standalone-module"
    "--enable-static"
    "--with-curl=${curl.dev}"
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-pcre=${pcre.dev}"
    "--with-apr=${apr.dev}"
    "--with-apu=${aprutil.dev}/bin/apu-1-config"
    "--with-libxml=${libxml2.dev}"
  ];

  outputs = ["out" "nginx"];

  preBuild = ''
    substituteInPlace apache2/Makefile.in --replace "install -D " "# install -D"
  '';

  postInstall = ''
    mkdir -p $nginx
    cp -R * $nginx
  '';

  meta = {
    description = "Open source, cross-platform web application firewall (WAF)";
    license = licenses.asl20;
    homepage = https://www.modsecurity.org/;
    maintainers = with maintainers; [offline];
    platforms = platforms.linux;
  };
}
