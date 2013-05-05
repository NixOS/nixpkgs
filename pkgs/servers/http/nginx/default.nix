{ stdenv, fetchurl, fetchgit, openssl, zlib, pcre, libxml2, libxslt, expat, fullWebDAV ? false }:

stdenv.mkDerivation rec {
  name = "nginx-1.2.4";

  src = fetchurl {
    url = "http://nginx.org/download/${name}.tar.gz";
    sha256 = "0hvcv4lgfcrsl40azkd3rxhf73l05jzzgflclpkdvjd95xgw51y5";
  };

  dav-ext = fetchgit {
    url = git://github.com/arut/nginx-dav-ext-module.git;
    rev = "54cebc1f21fc13391aae692c6cce672fa7986f9d";
    sha256 = "1dvpq1fg5rslnl05z8jc39sgnvh3akam9qxfl033akpczq1bh8nq";
  };

  buildInputs = [ openssl zlib pcre libxml2 libxslt ] ++ stdenv.lib.optional fullWebDAV expat;

  configureFlags = [
    "--with-http_ssl_module"
    "--with-http_xslt_module"
    "--with-http_sub_module"
    "--with-http_dav_module"
    "--with-http_gzip_static_module"
    "--with-http_secure_link_module"
    # Install destination problems
    # "--with-http_perl_module"
  ] ++ stdenv.lib.optional fullWebDAV "--add-module=${dav-ext}";

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${libxml2}/include/libxml2"
  '';

  postInstall = ''
    mv $out/sbin $out/bin
  '';

  meta = {
    description = "A reverse proxy and lightweight webserver";
    maintainers = [ stdenv.lib.maintainers.raskin];
    platforms = stdenv.lib.platforms.all;
  };
}
