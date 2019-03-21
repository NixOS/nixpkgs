{ stdenv, fetchurl, fetchpatch, openssl, zlib, pcre, libxml2, libxslt
, gd, geoip
, withDebug ? false
, withStream ? true
, withMail ? false
, modules ? []
, version, sha256, ...
}:

with stdenv.lib;

stdenv.mkDerivation {
  name = "nginx-${version}";

  src = fetchurl {
    url = "https://nginx.org/download/nginx-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ openssl zlib pcre libxml2 libxslt gd geoip ]
    ++ concatMap (mod: mod.inputs or []) modules;

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
    # Install destination problems
    # "--with-http_perl_module"
  ] ++ optional withDebug [
    "--with-debug"
  ] ++ optional withStream [
    "--with-stream"
    "--with-stream_geoip_module"
    "--with-stream_realip_module"
    "--with-stream_ssl_module"
    "--with-stream_ssl_preread_module"
  ] ++ optional withMail [
    "--with-mail"
    "--with-mail_ssl_module"
  ]
    ++ optional (gd != null) "--with-http_image_filter_module"
    ++ optional (with stdenv.hostPlatform; isLinux || isFreeBSD) "--with-file-aio"
    ++ map (mod: "--add-module=${mod.src}") modules;

  NIX_CFLAGS_COMPILE = [ "-I${libxml2.dev}/include/libxml2" ] ++ optional stdenv.isDarwin "-Wno-error=deprecated-declarations";

  configurePlatforms = [];

  preConfigure = (concatMapStringsSep "\n" (mod: mod.preConfigure or "") modules);

  patches = stdenv.lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/packages/master/net/nginx/patches/102-sizeof_test_fix.patch";
      sha256 = "0i2k30ac8d7inj9l6bl0684kjglam2f68z8lf3xggcc2i5wzhh8a";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/packages/master/net/nginx/patches/101-feature_test_fix.patch";
      sha256 = "0v6890a85aqmw60pgj3mm7g8nkaphgq65dj4v9c6h58wdsrc6f0y";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/packages/master/net/nginx/patches/103-sys_nerr.patch";
      sha256 = "0s497x6mkz947aw29wdy073k8dyjq8j99lax1a1mzpikzr4rxlmd";
    })
  ];

  hardeningEnable = optional (!stdenv.isDarwin) "pie";

  enableParallelBuilding = true;

  postInstall = ''
    mv $out/sbin $out/bin
  '';

  passthru.modules = modules;

  meta = {
    description = "A reverse proxy and lightweight webserver";
    homepage    = http://nginx.org;
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice raskin fpletz ];
  };
}
