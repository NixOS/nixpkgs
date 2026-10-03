{
  runCommand,
  replaceVars,
  writeText,
}:
let
  suffixSalt = "projection_test";
  utils = replaceVars ../../build-support/wrapper-common/utils.bash {
    inherit suffixSalt;
    wrapperName = "CC_WRAPPER";
    darwinMinVersion = "13.0";
    expandResponseParams = "";
  };
  sdk = replaceVars ../../build-support/wrapper-common/darwin-sdk-setup.bash {
    darwinMinVersion = "13.0";
    fallback_sdk = "/fallback-sdk";
  };
  check = writeText "check-sdk-projection.sh" ''
    source ${utils}
    source ${sdk}
    [[ $DEVELOPER_DIR == "$1" ]]
    [[ $SDKROOT == "$1/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk" ]]
    if (( $# > 1 )); then
      export NIX_CC_WRAPPER_TARGET_BUILD_projection_test=
      export NIX_CC_WRAPPER_TARGET_HOST_projection_test=1
      case "$2" in
        build)
          export NIX_CC_WRAPPER_TARGET_BUILD_projection_test=1
          export NIX_CC_WRAPPER_TARGET_HOST_projection_test=
          ;;
        replace) export DEVELOPER_DIR=/caller-sdk ;;
        empty) export DEVELOPER_DIR= ;;
        unset) unset DEVELOPER_DIR ;;
        both-empty)
          export NIX_CC_WRAPPER_TARGET_BUILD_projection_test=1 DEVELOPER_DIR=
          ;;
        both-unset)
          export NIX_CC_WRAPPER_TARGET_BUILD_projection_test=1
          unset DEVELOPER_DIR
          ;;
        salt) export DEVELOPER_DIR_projection_test=/caller-salt ;;
      esac
      exec "$BASH" -eu "$0" "$3"
    fi
  '';
  lateHooks = writeText "check-sdk-hooks.sh" ''
    source ${utils}
    source ${sdk}
    [[ $DEVELOPER_DIR == /host-sdk ]]
    [[ $SDKROOT == /host-sdk/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk ]]

    # A late hook can replace or unset the published tool environment. Exercise
    # the actual raw-exec boundary and the parent context used by post-link hooks.
    export DEVELOPER_DIR=/hook-sdk SDKROOT=/hook-sdk-root
    check='[[ $DEVELOPER_DIR == /hook-sdk && $SDKROOT == /hook-sdk-root ]]'
    (wrapperRun "" "$BASH" -eu -c "$check")
    eval "$check"
    unset DEVELOPER_DIR SDKROOT
    check='[[ ! -v DEVELOPER_DIR && ! -v SDKROOT ]]'
    (wrapperRun "" "$BASH" -eu -c "$check")
    eval "$check"
  '';
in
# Exercise the real SDK setup on every BUILD platform without a Darwin SDK or CC.
runCommand "cc-wrapper-role-projection" { } ''
  nestedSdk() {
    env -i DEVELOPER_DIR=/host-sdk DEVELOPER_DIR_FOR_BUILD=/build-sdk \
      NIX_CC_WRAPPER_TARGET_BUILD_projection_test=1 \
      "$BASH" -eu ${check} "$@"
  }
  nestedSdk /build-sdk inherit /host-sdk
  nestedSdk /build-sdk replace /caller-sdk
  nestedSdk /build-sdk empty /fallback-sdk
  nestedSdk /build-sdk unset /fallback-sdk
  nestedSdk /build-sdk both-unset /build-sdk
  env -i DEVELOPER_DIR=/host-sdk DEVELOPER_DIR_FOR_BUILD=/build-sdk \
    NIX_CC_WRAPPER_TARGET_HOST_projection_test=1 \
    "$BASH" -eu ${check} /host-sdk build /build-sdk

  # A genuine salted input must survive both invocations.
  env -i DEVELOPER_DIR_projection_test=/salted-sdk \
    "$BASH" -eu ${check} /salted-sdk inherit /salted-sdk

  # Empty is a defined HOST input; unset above is not. A caller's conflicting
  # salted value must also be rejected instead of discarded as a stale cache.
  for mode in both-empty salt; do
    if nestedSdk /build-sdk "$mode" /unused > "$mode.log" 2>&1; then
      echo "Expected conflicting SDK values for $mode" >&2
      exit 1
    else
      [[ $? == 1 ]]
    fi
    grep -Fq 'Multiple conflicting values defined for DEVELOPER_DIR_projection_test' "$mode.log"
  done
  env -i DEVELOPER_DIR=/host-sdk NIX_CC_WRAPPER_TARGET_HOST_projection_test=1 \
    "$BASH" -eu ${lateHooks}
  touch "$out"
''
