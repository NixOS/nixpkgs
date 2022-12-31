{ stdenvNoCC, xxd, cacert }:

stdenvNoCC.mkDerivation {
  name = "ca-bundle";

  nativeBuildInputs = [ cacert xxd ];

  phases = [ "installPhase" ];

  installPhase = ''
    set -euo pipefail

    if ! [ -f "$SSL_CERT_FILE" ]; then
      header "$SSL_CERT_FILE doesn't exist"
      exit 1
    fi

    mkdir include

    cat $SSL_CERT_FILE > include/ca-bundle.crt
    xxd -i include/ca-bundle.crt > ca-bundle.h

    mkdir -p $out/include

    mv ca-bundle.h $out/include
  '';

  preferLocalBuild = true;
}
