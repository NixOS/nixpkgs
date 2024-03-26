{ lib, stdenv, fetchFromGitHub, openssl, zlib, pcre, libxcrypt, libxml2, libxslt
, substituteAll, gd, geoip, gperftools, jemalloc, nixosTests
, withDebug ? false
, withMail ? false
, withStream ? false
, modules ? []
, ...
}:

with lib;

stdenv.mkDerivation rec {
  version = "3.1.0";
  pname = "tengine";

  src = fetchFromGitHub {
    owner = "alibaba";
    repo = pname;
    rev = version;
    hash = "sha256-cClSNBlresMHqJrqSFWvUo589TlwJ2tL5FWJG9QBuis=";
  };

  buildInputs =
    [ openssl zlib pcre libxcrypt libxml2 libxslt gd geoip gperftools jemalloc ]
    ++ concatMap (mod: mod.inputs or []) modules;

  patches = singleton (substituteAll {
    src = ../nginx/nix-etag-1.15.4.patch;
    preInstall = ''
      export nixStoreDir="$NIX_STORE" nixStoreDirLen="''${#NIX_STORE}"
    '';
  }) ++ [
    ./check-resolv-conf.patch
    ../nginx/nix-skip-check-logs-path.patch
  ];

  configureFlags = [
    "--with-http_ssl_module"
    "--with-http_v2_module"
    "--with-http_realip_module"
    "--with-http_addition_module"
    "--with-http_xslt_module"
    "--with-http_geoip_module"
    "--with-http_sub_module"
    "--with-http_dav_module"
    "--with-http_flv_module"
    "--with-http_mp4_module"
    "--with-http_gunzip_module"
    "--with-http_gzip_static_module"
    "--with-http_auth_request_module"
    "--with-http_random_index_module"
    "--with-http_secure_link_module"
    "--with-http_degradation_module"
    "--with-http_stub_status_module"
    "--with-threads"
    "--with-pcre-jit"
    "--with-http_slice_module"
    "--with-select_module"
    "--with-poll_module"
    "--with-google_perftools_module"
    "--with-jemalloc"
    "--http-log-path=/var/log/nginx/access.log"
    "--error-log-path=/var/log/nginx/error.log"
    "--pid-path=/var/log/nginx/nginx.pid"
    "--http-client-body-temp-path=/var/cache/nginx/client_body"
    "--http-proxy-temp-path=/var/cache/nginx/proxy"
    "--http-fastcgi-temp-path=/var/cache/nginx/fastcgi"
    "--http-uwsgi-temp-path=/var/cache/nginx/uwsgi"
    "--http-scgi-temp-path=/var/cache/nginx/scgi"
  ] ++ optionals withDebug [
    "--with-debug"
  ] ++ optionals withMail [
    "--with-mail"
    "--with-mail_ssl_module"
  ] ++ optionals (!withMail) [
    "--without-mail_pop3_module"
    "--without-mail_imap_module"
    "--without-mail_smtp_module"
  ] ++ optionals withStream [
    "--with-stream"
    "--with-stream_ssl_module"
    "--with-stream_realip_module"
    "--with-stream_geoip_module"
    "--with-stream_ssl_preread_module"
    "--with-stream_sni"
  ] ++ optionals (!withStream) [
    "--without-stream_limit_conn_module"
    "--without-stream_access_module"
    "--without-stream_geo_module"
    "--without-stream_map_module"
    "--without-stream_split_clients_module"
    "--without-stream_return_module"
    "--without-stream_upstream_hash_module"
    "--without-stream_upstream_least_conn_module"
    "--without-stream_upstream_random_module"
    "--without-stream_upstream_zone_module"
  ] ++ optional (gd != null) "--with-http_image_filter_module"
    ++ optional (with stdenv.hostPlatform; isLinux || isFreeBSD) "--with-file-aio"
    ++ map (mod: "--add-module=${mod.src}") modules;

  env.NIX_CFLAGS_COMPILE = "-I${libxml2.dev}/include/libxml2 -Wno-error=implicit-fallthrough"
    + optionalString stdenv.isDarwin " -Wno-error=deprecated-declarations";

  preConfigure = (concatMapStringsSep "\n" (mod: mod.preConfigure or "") modules);

  hardeningEnable = optional (!stdenv.isDarwin) "pie";

  enableParallelBuilding = true;

  postInstall = ''
    mv $out/sbin $out/bin
  '';

  passthru = {
    inherit modules;
    tests = nixosTests.nginx-variants.tengine;
  };

  meta = {
    description = "A web server based on Nginx and has many advanced features, originated by Taobao";
    mainProgram = "nginx";
    homepage    = "https://tengine.taobao.org";
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
