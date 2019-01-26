{ appleDerivation, Libinfo, configd, mDNSResponder }:

appleDerivation {
  buildInputs = [ Libinfo configd mDNSResponder ];

  buildPhase = ''
    cc -I. -c dns_util.c
    cc -I. -c dns.c
    cc -I. -c dns_async.c
    cc -I. -c base64.c
    cc -I. -c dst_api.c
    cc -I. -c dst_hmac_link.c
    cc -I. -c dst_support.c
    cc -I. -c ns_date.c
    cc -I. -c ns_name.c
    cc -I. -c ns_netint.c
    cc -I. -c ns_parse.c
    cc -I. -c ns_print.c
    cc -I. -c ns_samedomain.c
    cc -I. -c ns_sign.c
    cc -I. -c ns_ttl.c
    cc -I. -c ns_verify.c
    cc -I. -c res_comp.c
    cc -I. -c res_data.c
    cc -I. -c res_debug.c
    cc -I. -c res_findzonecut.c
    cc -I. -c res_init.c
    cc -I. -c res_mkquery.c
    cc -I. -c res_mkupdate.c
    cc -I. -c res_query.c
    cc -I. -c res_send.c
    cc -I. -c res_sendsigned.c
    cc -I. -c res_update.c
    cc -dynamiclib -install_name $out/lib/libresolv.9.dylib -current_version 1.0.0 -compatibility_version 1.0.0 -o libresolv.9.dylib *.o
  '';

  installPhase = ''
    mkdir -p $out/include $out/include/arpa $out/lib

    cp dns.h           $out/include/
    cp dns_util.h      $out/include
    cp nameser.h       $out/include
    ln -s ../nameser.h $out/include/arpa
    cp resolv.h        $out/include

    cp libresolv.9.dylib $out/lib
    ln -s libresolv.9.dylib $out/lib/libresolv.dylib
  '';
}
