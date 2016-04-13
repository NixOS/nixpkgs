{ stdenv, fetchurl, fetchFromGitHub, openssl, zlib, pcre, libxml2, libxslt, expat
, gd, geoip
, modules ? []
, hardening ? true
}:

with stdenv.lib;

let
  version = "1.8.1";
  mainSrc = fetchurl {
    url = "http://nginx.org/download/nginx-${version}.tar.gz";
    sha256 = "1dwpyw4pvhj68vxramqxm8f79pqz9lrm8mvifbn49h3615ikqjwg";
  };

in

stdenv.mkDerivation rec {
  name = "nginx-${version}";
  src = mainSrc;

  buildInputs =
    [ openssl zlib pcre libxml2 libxslt gd geoip ]
    ++ concatMap (mod: mod.inputs or []) modules;

  configureFlags = [
    "--with-select_module"
    "--with-poll_module"
    "--with-threads"
    "--with-http_ssl_module"
    "--with-http_spdy_module"
    "--with-http_realip_module"
    "--with-http_addition_module"
    "--with-http_xslt_module"
    "--with-http_image_filter_module"
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
    "--with-ipv6"
    # Install destination problems
    # "--with-http_perl_module"
  ] ++ optionals (elem stdenv.system (with platforms; linux ++ freebsd))
        [ "--with-file-aio" "--with-aio_module" ]
    ++ map (mod: "--add-module=${mod.src}") modules;

  NIX_CFLAGS_COMPILE = [ "-I${libxml2.dev}/include/libxml2" ] ++ optional stdenv.isDarwin "-Wno-error=deprecated-declarations -Wno-error=conditional-uninitialized";

  preConfigure = (concatMapStringsSep "\n" (mod: mod.preConfigure or "") modules)
    + optionalString (hardening && (stdenv.cc.cc.isGNU or false)) ''
      configureFlagsArray=(
        --with-cc-opt="-fPIE -fstack-protector-all --param ssp-buffer-size=4 -O2 -D_FORTIFY_SOURCE=2"
        --with-ld-opt="-pie -Wl,-z,relro,-z,now"
      )
    ''
    ;

  meta = {
    description = "A reverse proxy and lightweight webserver";
    homepage    = http://nginx.org;
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ thoughtpolice raskin ];
  };
}
