outer@{ lib, stdenv, fetchurl, fetchpatch, openssl, zlib, pcre, libxml2, libxslt
, nginx-doc

, nixosTests
, substituteAll, removeReferencesTo, gd, geoip, perl
, withDebug ? false
, withKTLS ? false
, withStream ? true
, withMail ? false
, withPerl ? true
, modules ? []
, ...
}:

{ pname ? "nginx"
, version
, nginxVersion ? version
, src ? null # defaults to upstream nginx ${version}
, sha256 ? null # when not specifying src
, configureFlags ? []
, buildInputs ? []
, extraPatches ? []
, fixPatch ? p: p
, preConfigure ? ""
, postInstall ? ""
, meta ? null
, nginx-doc ? outer.nginx-doc
, passthru ? { tests = {}; }
}:

with lib;

let

  mapModules = attrPath: flip concatMap modules
    (mod:
      let supports = mod.supports or (_: true);
      in
        if supports nginxVersion then mod.${attrPath} or []
        else throw "Module at ${toString mod.src} does not support nginx version ${nginxVersion}!");

in

stdenv.mkDerivation {
  inherit pname;
  inherit version;
  inherit nginxVersion;

  outputs = ["out" "doc"];

  src = if src != null then src else fetchurl {
    url = "https://nginx.org/download/nginx-${version}.tar.gz";
    inherit sha256;
  };

  buildInputs = [ openssl zlib pcre libxml2 libxslt gd geoip perl ]
    ++ buildInputs
    ++ mapModules "inputs";

  configureFlags = [
    "--with-http_ssl_module"
    "--with-http_v2_module"
    "--with-http_realip_module"
    "--with-http_addition_module"
    "--with-http_xslt_module"
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
  ] ++ optionals withKTLS [
    "--with-openssl-opt=enable-ktls"
  ] ++ optionals withStream [
    "--with-stream"
    "--with-stream_realip_module"
    "--with-stream_ssl_module"
    "--with-stream_ssl_preread_module"
  ] ++ optionals withMail [
    "--with-mail"
    "--with-mail_ssl_module"
  ] ++ optionals withPerl [
    "--with-http_perl_module"
    "--with-perl=${perl}/bin/perl"
    "--with-perl_modules_path=lib/perl5"
  ]
    ++ optional (gd != null) "--with-http_image_filter_module"
    ++ optional (geoip != null) "--with-http_geoip_module"
    ++ optional (withStream && geoip != null) "--with-stream_geoip_module"
    ++ optional (with stdenv.hostPlatform; isLinux || isFreeBSD) "--with-file-aio"
    ++ configureFlags
    ++ map (mod: "--add-module=${mod.src}") modules;

  NIX_CFLAGS_COMPILE = toString ([
    "-I${libxml2.dev}/include/libxml2"
    "-Wno-error=implicit-fallthrough"
  ] ++ optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") [
    # fix build vts module on gcc11
    "-Wno-error=stringop-overread"
  ] ++ optional stdenv.isDarwin "-Wno-error=deprecated-declarations");

  configurePlatforms = [];

  # Disable _multioutConfig hook which adds --bindir=$out/bin into configureFlags,
  # which breaks build, since nginx does not actually use autoconf.
  preConfigure = ''
    setOutputFlags=
  '' + preConfigure
     + concatMapStringsSep "\n" (mod: mod.preConfigure or "") modules;

  patches = map fixPatch ([
    (substituteAll {
      src = ./nix-etag-1.15.4.patch;
      preInstall = ''
        export nixStoreDir="$NIX_STORE" nixStoreDirLen="''${#NIX_STORE}"
      '';
    })
    ./nix-skip-check-logs-path.patch
  ] ++ optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/packages/c057dfb09c7027287c7862afab965a4cd95293a3/net/nginx/patches/102-sizeof_test_fix.patch";
      sha256 = "0i2k30ac8d7inj9l6bl0684kjglam2f68z8lf3xggcc2i5wzhh8a";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/packages/c057dfb09c7027287c7862afab965a4cd95293a3/net/nginx/patches/101-feature_test_fix.patch";
      sha256 = "0v6890a85aqmw60pgj3mm7g8nkaphgq65dj4v9c6h58wdsrc6f0y";
    })
    (fetchpatch {
      url = "https://raw.githubusercontent.com/openwrt/packages/c057dfb09c7027287c7862afab965a4cd95293a3/net/nginx/patches/103-sys_nerr.patch";
      sha256 = "0s497x6mkz947aw29wdy073k8dyjq8j99lax1a1mzpikzr4rxlmd";
    })
  ] ++ mapModules "patches")
    ++ extraPatches;

  hardeningEnable = optional (!stdenv.isDarwin) "pie";

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $doc
    cp -r ${nginx-doc}/* $doc
  '';

  nativeBuildInputs = [ removeReferencesTo ];

  disallowedReferences = map (m: m.src) modules;

  postInstall =
    let
      noSourceRefs = lib.concatMapStrings (m: "remove-references-to -t ${m.src} $out/sbin/nginx\n") modules;
    in noSourceRefs + postInstall;

  passthru = {
    modules = modules;
    tests = {
      inherit (nixosTests) nginx nginx-auth nginx-etag nginx-http3 nginx-pubhtml nginx-sandbox nginx-sso;
      variants = lib.recurseIntoAttrs nixosTests.nginx-variants;
      acme-integration = nixosTests.acme;
    } // passthru.tests;
  };

  meta = if meta != null then meta else {
    description = "A reverse proxy and lightweight webserver";
    homepage    = "http://nginx.org";
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice raskin fpletz globin ajs124 ];
  };
}
