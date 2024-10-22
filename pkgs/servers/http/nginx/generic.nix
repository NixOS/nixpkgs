outer@{ lib, stdenv, fetchurl, fetchpatch, openssl, zlib, pcre, libxml2, libxslt
, nginx-doc

, nixosTests
, installShellFiles, substituteAll, removeReferencesTo, gd, geoip, perl
, withDebug ? false
, withGeoIP ? false
, withImageFilter ? false
, withKTLS ? true
, withStream ? true
, withMail ? false
, withPerl ? true
, withSlice ? false
, modules ? []
, ...
}:

{ pname ? "nginx"
, version
, nginxVersion ? version
, src ? null # defaults to upstream nginx ${version}
, hash ? null # when not specifying src
, configureFlags ? []
, nativeBuildInputs ? []
, buildInputs ? []
, extraPatches ? []
, fixPatch ? p: p
, postPatch ? ""
, preConfigure ? ""
, preInstall ? ""
, postInstall ? ""
, meta ? null
, nginx-doc ? outer.nginx-doc
, passthru ? { tests = {}; }
}:

let

  moduleNames = map (mod: mod.name or (throw "The nginx module with source ${toString mod.src} does not have a `name` attribute. This prevents duplicate module detection and is no longer supported."))
    modules;

  mapModules = attrPath: lib.flip lib.concatMap modules
    (mod:
      let supports = mod.supports or (_: true);
      in
        if supports nginxVersion then mod.${attrPath} or []
        else throw "Module at ${toString mod.src} does not support nginx version ${nginxVersion}!");

in

assert lib.assertMsg (lib.unique moduleNames == moduleNames)
  "nginx: duplicate modules: ${lib.concatStringsSep ", " moduleNames}. A common cause for this is that services.nginx.additionalModules adds a module which the nixos module itself already adds.";

stdenv.mkDerivation {
  inherit pname version nginxVersion;

  outputs = [ "out" "doc" ];

  src = if src != null then src else fetchurl {
    url = "https://nginx.org/download/nginx-${version}.tar.gz";
    inherit hash;
  };

  nativeBuildInputs = [
    installShellFiles
    removeReferencesTo
  ] ++ nativeBuildInputs;

  buildInputs = [ openssl zlib pcre libxml2 libxslt perl ]
    ++ buildInputs
    ++ mapModules "inputs"
    ++ lib.optional withGeoIP geoip
    ++ lib.optional withImageFilter gd;

  configureFlags = [
    "--sbin-path=bin/nginx"
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
    "--http-client-body-temp-path=/tmp/nginx_client_body"
    "--http-proxy-temp-path=/tmp/nginx_proxy"
    "--http-fastcgi-temp-path=/tmp/nginx_fastcgi"
    "--http-uwsgi-temp-path=/tmp/nginx_uwsgi"
    "--http-scgi-temp-path=/tmp/nginx_scgi"
  ] ++ lib.optionals withDebug [
    "--with-debug"
  ] ++ lib.optionals withKTLS [
    "--with-openssl-opt=enable-ktls"
  ] ++ lib.optionals withStream [
    "--with-stream"
    "--with-stream_realip_module"
    "--with-stream_ssl_module"
    "--with-stream_ssl_preread_module"
  ] ++ lib.optionals withMail [
    "--with-mail"
    "--with-mail_ssl_module"
  ] ++ lib.optionals withPerl [
    "--with-http_perl_module"
    "--with-perl=${perl}/bin/perl"
    "--with-perl_modules_path=lib/perl5"
  ] ++ lib.optional withImageFilter "--with-http_image_filter_module"
    ++ lib.optional withSlice "--with-http_slice_module"
    ++ lib.optionals withGeoIP ([ "--with-http_geoip_module" ] ++ lib.optional withStream "--with-stream_geoip_module")
    ++ lib.optional (with stdenv.hostPlatform; isLinux || isFreeBSD) "--with-file-aio"
    ++ configureFlags
    ++ map (mod: "--add-module=${mod.src}") modules;

  env.NIX_CFLAGS_COMPILE = toString ([
    "-I${libxml2.dev}/include/libxml2"
    "-Wno-error=implicit-fallthrough"
  ] ++ lib.optionals (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "11") [
    # fix build vts module on gcc11
    "-Wno-error=stringop-overread"
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=gnu-folding-constant"
    "-Wno-error=unused-but-set-variable"
  ] ++ lib.optionals stdenv.hostPlatform.isMusl [
    # fix sys/cdefs.h is deprecated
    "-Wno-error=cpp"
  ]);

  configurePlatforms = [];

  # Disable _multioutConfig hook which adds --bindir=$out/bin into configureFlags,
  # which breaks build, since nginx does not actually use autoconf.
  preConfigure = ''
    setOutputFlags=
  '' + preConfigure
     + lib.concatMapStringsSep "\n" (mod: mod.preConfigure or "") modules;

  patches = map fixPatch ([
    (substituteAll {
      src = ./nix-etag-1.15.4.patch;
      preInstall = ''
        export nixStoreDir="$NIX_STORE" nixStoreDirLen="''${#NIX_STORE}"
      '';
    })
    ./nix-skip-check-logs-path.patch
  ] ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
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

  inherit postPatch;

  hardeningEnable = lib.optional (!stdenv.hostPlatform.isDarwin) "pie";

  enableParallelBuilding = true;

  preInstall = ''
    mkdir -p $doc
    cp -r ${nginx-doc}/* $doc

    # TODO: make it unconditional when `openresty` and `nginx` are not
    # sharing this code.
    if [[ -e man/nginx.8 ]]; then
      installManPage man/nginx.8
    fi
  '' + preInstall;

  disallowedReferences = map (m: m.src) modules;

  postInstall =
    let
      noSourceRefs = lib.concatMapStrings (m: "remove-references-to -t ${m.src} $out/bin/nginx\n") modules;
    in noSourceRefs + postInstall;

  passthru = {
    inherit modules;
    tests = {
      inherit (nixosTests) nginx nginx-auth nginx-etag nginx-etag-compression nginx-globalredirect nginx-http3 nginx-proxyprotocol nginx-pubhtml nginx-sso nginx-status-page nginx-unix-socket;
      variants = lib.recurseIntoAttrs nixosTests.nginx-variants;
      acme-integration = nixosTests.acme;
    } // passthru.tests;
  };

  meta = if meta != null then meta else with lib; {
    description = "Reverse proxy and lightweight webserver";
    mainProgram = "nginx";
    homepage    = "http://nginx.org";
    license     = [ licenses.bsd2 ]
      ++ concatMap (m: m.meta.license) modules;
    platforms   = platforms.all;
    maintainers = with maintainers; [ fpletz raitobezarius ] ++ teams.helsinki-systems.members ++ teams.stridtech.members;
  };
}
