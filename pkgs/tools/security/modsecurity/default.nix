{ stdenv, lib, fetchurl, pkgconfig
, curl, apacheHttpd, pcre, apr, aprutil, libxml2
, luaSupport ? false, lua5
}:

with lib;

let luaValue = if luaSupport then lua5 else "no";
    optional = stdenv.lib.optional;
in

stdenv.mkDerivation rec {
  name = "modsecurity-${version}";
  version = "2.9.2";

  src = fetchurl {
    url = "https://www.modsecurity.org/tarball/${version}/${name}.tar.gz";
    sha256 = "41a8f73476ec891f3a9e8736b98b64ea5c2105f1ce15ea57a1f05b4bf2ffaeb5";
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
