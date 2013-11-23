{ stdenv, fetchurl, fetchgit, openssl, zlib, pcre, libxml2, libxslt, expat
, rtmp ? false
, fullWebDAV ? false
, syslog ? false}:

let
  rtmp-ext = fetchgit {
    url = git://github.com/arut/nginx-rtmp-module.git;
    rev = "1cfb7aeb582789f3b15a03da5b662d1811e2a3f1";
    sha256 = "03ikfd2l8mzsjwx896l07rdrw5jn7jjfdiyl572yb9jfrnk48fwi";
  };

  dav-ext = fetchgit {
    url = git://github.com/arut/nginx-dav-ext-module.git;
    rev = "54cebc1f21fc13391aae692c6cce672fa7986f9d";
    sha256 = "1dvpq1fg5rslnl05z8jc39sgnvh3akam9qxfl033akpczq1bh8nq";
  };

  syslog-ext = fetchgit {
    url = https://github.com/yaoweibin/nginx_syslog_patch.git;
    rev = "165affd9741f0e30c4c8225da5e487d33832aca3";
    sha256 = "14dkkafjnbapp6jnvrjg9ip46j00cr8pqc2g7374z9aj7hrvdvhs";
  };
in

stdenv.mkDerivation rec {
  name = "nginx-${meta.version}";

  src = fetchurl {
    url = "http://nginx.org/download/${name}.tar.gz";
    sha256 = "116yfy0k65mwxdkld0w7c3gly77jdqlvga5hpbsw79i3r62kh4mf";
  };

  buildInputs = [ openssl zlib pcre libxml2 libxslt
    ] ++ stdenv.lib.optional fullWebDAV expat;

  patches = if syslog then [ "${syslog-ext}/syslog_1.4.0.patch" ] else [];

  configureFlags = [
    "--with-http_ssl_module"
    "--with-http_xslt_module"
    "--with-http_sub_module"
    "--with-http_dav_module"
    "--with-http_gzip_static_module"
    "--with-http_secure_link_module"
    # Install destination problems
    # "--with-http_perl_module"
  ] ++ stdenv.lib.optional rtmp "--add-module=${rtmp-ext}"
    ++ stdenv.lib.optional fullWebDAV "--add-module=${dav-ext}"
    ++ stdenv.lib.optional syslog "--add-module=${syslog-ext}";

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
    version = "1.4.3";
  };
}
