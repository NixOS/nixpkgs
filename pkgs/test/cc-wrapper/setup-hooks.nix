{
  lib,
  stdenv,
  stdenvNoCC,
  makeSetupHook,
  replaceVars,
  writeText,
  writeTextDir,
  zlib,
}:
let
  cc = stdenv.cc;
  bintools = cc.bintools;
  bintoolsSalt = bintools.suffixSalt or bintools.env.suffixSalt;
  roles = [
    "BUILD"
    "HOST"
    "TARGET"
  ];
  variables = [
    "PATH"
    "_PATH"
    "CC"
    "CXX"
    "FC"
    "AR"
    "LD"
    "NIX_CC"
    "NIX_BINTOOLS"
    "NIX_HARDENING_ENABLE"
  ]
  ++ lib.concatMap (role: [
    "NIX_CC_WRAPPER_TARGET_${role}_${cc.suffixSalt}"
    "NIX_BINTOOLS_WRAPPER_TARGET_${role}_${bintoolsSalt}"
  ]) roles;
  roleHook =
    wrapperName: suffixSalt:
    replaceVars ../../build-support/setup-hooks/role.bash {
      name = "cc-wrapper-collector-test";
      inherit wrapperName suffixSalt;
    };
  register = makeSetupHook { name = "cc-wrapper-collectors-only-hook"; } (
    writeText "cc-wrapper-collectors-only-hook.sh" ''
      source ${roleHook "COLLECTOR_TEST" cc.suffixSalt}
      registerTestCollectors() {
        local -A before=()
        local variable targetOffset
        for variable in ${lib.escapeShellArgs variables}; do
          before[$variable]="$(declare -p "$variable" 2>/dev/null || true)"
        done
        local markerFunction="$(declare -f getTargetRoleWrapper)"
        # One wrapper may be used in every role. Registration must not have a
        # once-per-wrapper guard, nor activate any of the wrapper's tools.
        for targetOffset in -1 0 1; do
          source ${bintools}/nix-support/add-env-hooks.sh
          source ${cc}/nix-support/add-env-hooks.sh
        done
        for variable in "''${!before[@]}"; do
          [[ $(declare -p "$variable" 2>/dev/null || true) == "''${before[$variable]}" ]]
        done
        [[ $(declare -f getTargetRoleWrapper) == "$markerFunction" ]]
      }
      registerTestCollectors
      unset -f registerTestCollectors
    ''
  );
  headers = lib.genAttrs roles (
    role: writeTextDir "include/cc-wrapper-${role}.h" "#define WRAPPER_${role} 42\n"
  );
  libcBin = lib.optionalString (cc.libc != null) (lib.getBin cc.libc);
  canRunLibc = cc.stdenv.hostPlatform.canExecute cc.stdenv.targetPlatform;
in
{
  collectors = stdenvNoCC.mkDerivation {
    name = "cc-wrapper-collectors-only-test";
    strictDeps = true;
    nativeBuildInputs = [ register ];
    depsBuildBuild = [ headers.BUILD ];
    buildInputs = [
      headers.HOST
      zlib
    ];
    depsTargetTarget = [ headers.TARGET ];
    buildCommand = ''
      [[ $NIX_CFLAGS_COMPILE_FOR_BUILD == *'${headers.BUILD}/include'* ]]
      [[ $NIX_CFLAGS_COMPILE_FOR_BUILD != *'${headers.HOST}/include'* ]]
      [[ $NIX_CFLAGS_COMPILE == *'${headers.HOST}/include'* ]]
      [[ $NIX_CFLAGS_COMPILE != *'${headers.TARGET}/include'* ]]
      [[ $NIX_CFLAGS_COMPILE_FOR_TARGET == *'${headers.TARGET}/include'* ]]
      [[ $NIX_CFLAGS_COMPILE_FOR_TARGET != *'${headers.BUILD}/include'* ]]
      cat > main.c <<'C'
      #include <cc-wrapper-HOST.h>
      #include <string.h>
      #include <zlib.h>
      int main(void) {
        return WRAPPER_HOST != 42 || strcmp(zlibVersion(), ZLIB_VERSION);
      }
      C
      # Direct invocation in stdenvNoCC selects its role separately from
      # registering collectors, which must not activate compiler tools.
      targetOffset=0
      source ${roleHook "CC_WRAPPER" cc.suffixSalt}
      getTargetRoleWrapper
      source ${roleHook "BINTOOLS_WRAPPER" bintoolsSalt}
      getTargetRoleWrapper
      ${cc}/bin/${cc.targetPrefix}cc main.c -lz -o "$out"
      ${lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''"$out"''}
    '';
  };

  libc-path =
    assert cc.libc_bin == libcBin;
    assert bintools.libc_bin == libcBin;
    stdenv.mkDerivation {
      name = "cc-wrapper-libc-path-test";
      strictDeps = true;
      buildCommand =
        lib.optionalString (libcBin != "") ''
          # Metadata remains usable to embed HOST's ldd into an installed
          # package even when BUILD cannot run that binary.
          test -d ${libcBin}
          ${if canRunLibc then "" else "!"} [[ :$PATH: == *':${libcBin}/bin:'* ]]
          ${if canRunLibc then "" else "!"} grep -Fw ${libcBin} \
            ${bintools}/nix-support/propagated-user-env-packages
        ''
        + ''
          touch "$out"
        '';
    };
}
