preInstallPhases+=" moduleSignPhase"

moduleSignPhase() {
    runHook preModuleSign

    if [ ! -z "@hash@" ] && [ -f "@kernel@/certs/signing_key.pem" ] && [ -f "@kernel@/certs/signing_key.x509" ]; then
      for mod in `find -name '*.ko'`; do
        echo "signing '$mod'"
        @kernel@/scripts/sign-file @hash@ @kernel@/certs/signing_key.pem @kernel@/certs/signing_key.x509 "$mod"
      done
    fi

    runHook postModuleSign
}
