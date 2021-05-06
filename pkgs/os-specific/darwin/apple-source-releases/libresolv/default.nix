{ lib, appleDerivation', stdenv, Libinfo, configd, mDNSResponder
, headersOnly ? false
}:

appleDerivation' stdenv {
  buildInputs = lib.optionals (!headersOnly) [ Libinfo configd mDNSResponder ];

  buildPhase = lib.optionalString (!headersOnly) ''
    ${stdenv.cc.targetPrefix or ""}cc -I. -c dns_util.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c dns.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c dns_async.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c base64.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c dst_api.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c dst_hmac_link.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c dst_support.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_date.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_name.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_netint.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_parse.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_print.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_samedomain.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_sign.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_ttl.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c ns_verify.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_comp.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_data.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_debug.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_findzonecut.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_init.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_mkquery.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_mkupdate.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_query.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_send.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_sendsigned.c
    ${stdenv.cc.targetPrefix or ""}cc -I. -c res_update.c
    ${stdenv.cc.targetPrefix or ""}cc -dynamiclib -install_name $out/lib/libresolv.9.dylib -current_version 1.0.0 -compatibility_version 1.0.0 -o libresolv.9.dylib *.o
  '';

  installPhase = ''
    mkdir -p $out/include $out/include/arpa $out/lib

    cp dns.h           $out/include/
    cp dns_util.h      $out/include
    cp nameser.h       $out/include
    ln -s ../nameser.h $out/include/arpa
    cp resolv.h        $out/include
  '' + lib.optionalString (!headersOnly) ''

    cp libresolv.9.dylib $out/lib
    ln -s libresolv.9.dylib $out/lib/libresolv.dylib
  '';
}
