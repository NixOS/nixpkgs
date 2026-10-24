{
  brotli,
  fetchFromGitHub,
  lib,
  stdenv,
  nginx,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brotli";
  version = "1.0.0rc-unstable-2023-10-09";

  src = fetchFromGitHub {
    owner = "google";
    repo = "ngx_brotli";
    rev = "a71f9312c2deb28875acc7bacfdd5695a111aa53";
    hash = "sha256-5XSEqXyaIKoUzs1OC6WGPwqpx8JWaE0aMlfjvOoYs3U=";
  };

  buildInputs = [ brotli nginx ] ++ nginx.buildInputs;
  nativeBuildInputs = [ pkg-config ];

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/modules

    cat >static/modules.c <<EOF
    #include <ngx_config.h>
    #include <ngx_core.h>

    extern ngx_module_t ngx_http_brotli_static_module;

    ngx_module_t* ngx_modules[] = {
        &ngx_http_brotli_static_module,
        NULL
    };

    char* ngx_module_names[] = {
        "ngx_http_brotli_static_module",
        NULL
    };
    EOF

    $CC static/*.c -shared -o $out/modules/ngx_http_brotli_static_module.so

    cat >filter/modules.c <<EOF
    #include <ngx_config.h>
    #include <ngx_core.h>

    extern ngx_module_t ngx_http_brotli_filter_module;

    ngx_module_t* ngx_modules[] = {
        &ngx_http_brotli_filter_module,
        NULL
    };

    char* ngx_module_names[] = {
        "ngx_http_brotli_filter_module",
        NULL
    };
    EOF
    $CC filter/*.c -lbrotlienc -lbrotlidec -shared -o $out/modules/ngx_http_brotli_filter_module.so

    runHook postBuild
  '';

  dontInstall = true;

  meta = {
    description = "Brotli compression";
    homepage = "https://github.com/google/ngx_brotli";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
})
