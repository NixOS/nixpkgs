{ stdenv, lib, fetchurl, pkgconfig
, curl, apacheHttpd, pcre, apr, aprutil, libxml2
, luaSupport ? false, lua5
}:

with lib;

let luaValue = if luaSupport then lua5 else "no";
    optional = stdenv.lib.optional;
in

stdenv.mkDerivation rec {
  pname = "modsecurity";
  version = "2.9.3";

  src = fetchurl {
    url = "https://www.modsecurity.org/tarball/${version}/${pname}-${version}.tar.gz";
    sha256 = "0611nskd2y6yagrciqafxdn4rxbdk2v4swf45kc1sgwx2sfh34j1";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [  curl apacheHttpd pcre apr aprutil libxml2 ] ++
    optional luaSupport lua5;

  configureFlags = [
    "--enable-standalone-module"
    "--enable-static"
    "--with-curl=${curl.dev}"
    "--with-apxs=${apacheHttpd.dev}/bin/apxs"
    "--with-pcre=${pcre.dev}"
    "--with-apr=${apr.dev}"
    "--with-apu=${aprutil.dev}/bin/apu-1-config"
    "--with-libxml=${libxml2.dev}"
    "--with-lua=${luaValue}"
  ];

  outputs = ["out" "nginx"];
  # by default modsecurity's install script copies compiled output to httpd's modules folder
  # this patch removes those lines
  patches = [ ./Makefile.in.patch ];

  postInstall = ''
    mkdir -p $nginx
    cp -R * $nginx
  '';

  meta = {
    description = "Open source, cross-platform web application firewall (WAF)";
    license = licenses.asl20;
    homepage = https://www.modsecurity.org/;
    maintainers = with maintainers; [offline];
    platforms   = stdenv.lib.platforms.linux ++ stdenv.lib.platforms.darwin;
  };
}
