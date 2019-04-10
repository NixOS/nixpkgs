{ stdenv, fetchurl, openssl, zlib, pcre, libxml2, libxslt
, gd, geoip
, withDebug ? false
, withMail ? false
, withIPv6 ? true
, modules ? []
, ...
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "2.2.3";
  name = "tengine-${version}";

  src = fetchurl {
    url = "https://github.com/alibaba/tengine/archive/${version}.tar.gz";
    sha256 = "0x12mfs0q7lihpl335ad222a1a2sdkqzj5q8zbybzr20frixjs42";
  };

  buildInputs =
    [ openssl zlib pcre libxml2 libxslt gd geoip ]
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
    "--with-http_concat_module"
    "--with-http_random_index_module"
    "--with-http_secure_link_module"
    "--with-http_degradation_module"
    "--with-http_stub_status_module"
    "--with-http_sysguard_module"
    "--with-threads"
    "--with-pcre-jit"
    "--with-http_slice_module"
  ] ++ optional withDebug [
    "--with-debug"
  ] ++ optional withMail [
    "--with-mail"
    "--with-mail_ssl_module"
  ] ++ optional (withMail != true) [
    "--without-mail_pop3_module"
    "--without-mail_imap_module"
    "--without-mail_smtp_module"
  ] ++ optional withIPv6 [
    "--with-ipv6"
  ] ++ optional (gd != null) "--with-http_image_filter_module"
    ++ optional (with stdenv.hostPlatform; isLinux || isFreeBSD) "--with-file-aio"
    ++ map (mod: "--add-module=${mod.src}") modules;

  NIX_CFLAGS_COMPILE = [
    "-I${libxml2.dev}/include/libxml2"
    "-Wno-error=implicit-fallthrough"
  ] ++ optional stdenv.isDarwin "-Wno-error=deprecated-declarations";

  preConfigure = (concatMapStringsSep "\n" (mod: mod.preConfigure or "") modules);

  hardeningEnable = optional (!stdenv.isDarwin) "pie";

  enableParallelBuilding = true;

  postInstall = ''
    mv $out/sbin $out/bin
  '';

  meta = {
    description = "A web server based on Nginx and has many advanced features, originated by Taobao.";
    homepage    = https://tengine.taobao.org;
    license     = licenses.bsd2;
    platforms   = platforms.all;
    maintainers = with maintainers; [ izorkin ];
  };
}
