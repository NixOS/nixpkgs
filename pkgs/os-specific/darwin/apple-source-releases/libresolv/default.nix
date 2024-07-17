{
  lib,
  appleDerivation',
  stdenv,
  stdenvNoCC,
  Libinfo,
  configdHeaders,
  mDNSResponder,
  headersOnly ? false,
}:

appleDerivation' (if headersOnly then stdenvNoCC else stdenv) {
  buildInputs = lib.optionals (!headersOnly) [
    Libinfo
    configdHeaders
    mDNSResponder
  ];

  buildPhase = lib.optionalString (!headersOnly) ''
    $CC -I. -c dns_util.c
    $CC -I. -c dns.c
    $CC -I. -c dns_async.c
    $CC -I. -c base64.c
    $CC -I. -c dst_api.c
    $CC -I. -c dst_hmac_link.c
    $CC -I. -c dst_support.c
    $CC -I. -c ns_date.c
    $CC -I. -c ns_name.c
    $CC -I. -c ns_netint.c
    $CC -I. -c ns_parse.c
    $CC -I. -c ns_print.c
    $CC -I. -c ns_samedomain.c
    $CC -I. -c ns_sign.c
    $CC -I. -c ns_ttl.c
    $CC -I. -c ns_verify.c
    $CC -I. -c res_comp.c
    $CC -I. -c res_data.c
    $CC -I. -c res_debug.c
    $CC -I. -c res_findzonecut.c
    $CC -I. -c res_init.c
    $CC -I. -c res_mkquery.c
    $CC -I. -c res_mkupdate.c
    $CC -I. -c res_query.c
    $CC -I. -c res_send.c
    $CC -I. -c res_sendsigned.c
    $CC -I. -c res_update.c
    $CC -dynamiclib -install_name $out/lib/libresolv.9.dylib -current_version 1.0.0 -compatibility_version 1.0.0 -o libresolv.9.dylib *.o
  '';

  installPhase =
    ''
      mkdir -p $out/include $out/include/arpa $out/lib

      cp dns.h           $out/include/
      cp dns_util.h      $out/include
      cp nameser.h       $out/include
      ln -s ../nameser.h $out/include/arpa
      cp resolv.h        $out/include
    ''
    + lib.optionalString (!headersOnly) ''

      cp libresolv.9.dylib $out/lib
      ln -s libresolv.9.dylib $out/lib/libresolv.dylib
    '';
}
