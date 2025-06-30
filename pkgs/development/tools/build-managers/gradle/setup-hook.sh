gradleConfigureHook() {
    if [ -z "${GRADLE_USER_HOME-}" ]; then
        GRADLE_USER_HOME="$(mktemp -d)"
    fi
    export GRADLE_USER_HOME
    export TERM=dumb
    gradleFlagsArray+=(--no-daemon --console plain --init-script "${gradleInitScript:-@init_script@}")
    if [ -n "${MITM_CACHE_CA-}" ]; then
        if [ -z "${MITM_CACHE_KEYSTORE-}" ]; then
            MITM_CACHE_KEYSTORE="$MITM_CACHE_CERT_DIR/keystore"
            MITM_CACHE_KS_PWD="$(head -c10 /dev/random | base32)"
            echo y | @jdk@/bin/keytool -importcert -file "$MITM_CACHE_CA" -alias alias -keystore "$MITM_CACHE_KEYSTORE" -storepass "$MITM_CACHE_KS_PWD"
        fi
        gradleFlagsArray+=(-Dhttp.proxyHost="$MITM_CACHE_HOST" -Dhttp.proxyPort="$MITM_CACHE_PORT")
        gradleFlagsArray+=(-Dhttps.proxyHost="$MITM_CACHE_HOST" -Dhttps.proxyPort="$MITM_CACHE_PORT")
        gradleFlagsArray+=(-Djavax.net.ssl.trustStore="$MITM_CACHE_KEYSTORE" -Djavax.net.ssl.trustStorePassword="$MITM_CACHE_KS_PWD")
    else
        gradleFlagsArray+=(--offline)
    fi
    if ! [[ -v enableParallelBuilding ]]; then
        enableParallelBuilding=1
    fi
    if ! [[ -v enableParallelChecking ]]; then
        enableParallelChecking=1
    fi
    if ! [[ -v enableParallelUpdating ]]; then
        enableParallelUpdating=1
    fi
}

gradle() {
    local flagsArray=()
    concatTo flagsArray gradleFlags gradleFlagsArray
    command gradle "${flagsArray[@]}" "$@"
}

gradleBuildPhase() {
    runHook preBuild

    gradle ${enableParallelBuilding:+--parallel} ${gradleBuildTask:-assemble}

    runHook postBuild
}

gradleCheckPhase() {
    runHook preCheck

    gradle ${enableParallelChecking:+--parallel} ${gradleCheckTask:-test}

    runHook postCheck
}

gradleUpdateScript() {
    runHook preBuild
    runHook preGradleUpdate

    gradle ${enableParallelUpdating:+--parallel} ${gradleUpdateTask:-nixDownloadDeps}

    runHook postGradleUpdate
}

if [ -z "${dontUseGradleConfigure-}" ]; then
    preConfigureHooks+=(gradleConfigureHook)
fi

if [ -z "${dontUseGradleBuild-}" ] && [ -z "${buildPhase-}" ]; then
    buildPhase=gradleBuildPhase
fi

if [ -z "${dontUseGradleCheck-}" ] && [ -z "${checkPhase-}" ]; then
    checkPhase=gradleCheckPhase
fi
