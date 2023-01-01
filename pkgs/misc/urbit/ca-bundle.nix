{ runCommandLocal, xxd, cacert }:

runCommandLocal "ca-bundle" {} ''
    mkdir include

    cat ${cacert}/etc/ssl/certs/ca-bundle.crt > include/ca-bundle.crt
    ${xxd}/bin/xxd -i include/ca-bundle.crt > ca-bundle.h

    mkdir -p $out/include

    mv ca-bundle.h $out/include
  ''
