{
  lib,
  stdenv,
  CC,
  emulator,
  staticLibc,
}:
let
  inherit (stdenv.cc) suffixSalt targetPrefix;
  rawCC = lib.getExe' stdenv.cc.cc "${targetPrefix}${if stdenv.cc.isClang then "clang" else "gcc"}";
  rawCXX = lib.getExe' stdenv.cc.cc "${targetPrefix}${
    if stdenv.cc.isClang then "clang++" else "g++"
  }";
  rawLD = lib.getExe' stdenv.cc.bintools.bintools "${targetPrefix}ld";
  child = stdenv.cc.override (old: {
    extraBuildCommands = (old.extraBuildCommands or "") + ''
      echo ' -DWRAPPER_POLICY=2' >> "$out/nix-support/cc-cflags"
    '';
  });
  parent = stdenv.cc.override (old: {
    extraBuildCommands = (old.extraBuildCommands or "") + ''
      echo ' -DWRAPPER_POLICY=1' >> "$out/nix-support/cc-cflags"
      mkdir -p "$out/nix-support/operation-include"
      echo '#define OPERATION_HEADER 42' > "$out/nix-support/operation-include/operation-header.h"
      echo " -isystem $out/nix-support/operation-include" >> "$out/nix-support/libc-cflags"
      cat > "$out/nix-support/cc-wrapper-hook" <<'EOF'
      case "''${WRAPPER_TEST_ENTRY:-}" in
        nested)
          # A hook is outside the raw compiler's linker continuation. Its
          # independent compiler must select its own defaults and current role.
          env NIX_CC_WRAPPER_TARGET_HOST_${suffixSalt}= \
            NIX_CC_WRAPPER_TARGET_BUILD_${suffixSalt}=1 \
            NIX_CC_WRAPPER_TARGET_TARGET_${suffixSalt}= \
            ${child}/bin/${targetPrefix}cc -c ${./cc-main.c} \
            -include ${./operation-policy.h} -DEXPECTED_POLICY=2 \
            -DEXPECTED_ROLE=2 -DEXPECTED_RAW="$WRAPPER_TEST_EXPECTED_RAW" \
            -o "$WRAPPER_TEST_CHILD_OBJECT"
          case "$WRAPPER_TEST_SEED" in
            unset) [[ ! -v NIX_CFLAGS_COMPILE_${suffixSalt} ]] ;;
            empty) [[ -v NIX_CFLAGS_COMPILE_${suffixSalt} && -z $NIX_CFLAGS_COMPILE_${suffixSalt} ]] ;;
            value) [[ $NIX_CFLAGS_COMPILE_${suffixSalt} == '-DRAW_SEED=1' ]] ;;
          esac
          ;;
      esac
      EOF
    '';
  });
in
''
  echo "checking independent nested compilers and caller inputs..." >&2
  for seed in unset empty value; do
    raw=0
    seedEnv=(-u NIX_CFLAGS_COMPILE_${suffixSalt})
    if [[ $seed == empty ]]; then seedEnv=(NIX_CFLAGS_COMPILE_${suffixSalt}=); fi
    if [[ $seed == value ]]; then
      seedEnv=(NIX_CFLAGS_COMPILE_${suffixSalt}=-DRAW_SEED=1)
      raw=1
    fi
    env "''${seedEnv[@]}" \
      NIX_CC_WRAPPER_TARGET_HOST_${suffixSalt}=1 \
      NIX_CC_WRAPPER_TARGET_BUILD_${suffixSalt}= \
      NIX_CC_WRAPPER_TARGET_TARGET_${suffixSalt}= \
      NIX_CFLAGS_COMPILE=-DROLE_SEED=1 \
      NIX_CFLAGS_COMPILE_FOR_BUILD=-DROLE_SEED=2 \
      WRAPPER_TEST_ENTRY=nested WRAPPER_TEST_SEED="$seed" \
      WRAPPER_TEST_EXPECTED_RAW="$raw" \
      WRAPPER_TEST_CHILD_OBJECT="$PWD/child-$seed.o" \
      ${parent}/bin/${targetPrefix}cc ${./cc-main.c} \
      -include ${./operation-policy.h} -DEXPECTED_POLICY=1 \
      -DEXPECTED_ROLE=1 -DEXPECTED_RAW="$raw" -o "parent-$seed"
    ${emulator} ./parent-$seed
    ${CC} "child-$seed.o" -o "child-$seed"
    ${emulator} ./child-$seed
  done

  echo "checking prepared compiler entry and fresh public entry..." >&2
  # A multi-driver selects its defaults once, then binds the actual terminal
  # job. Use the installed preparation helpers; the terminal remains the full
  # compiler wrapper, including argument parsing, hooks and response files.
  cat > prepare-operation <<'EOF'
  set -eu
  path_backup=$PATH
  cInclude=''${WRAPPER_TEST_C_INCLUDE:-1}
  source ${parent}/nix-support/utils.bash
  wrapperClear
  source ${parent}/nix-support/darwin-sdk-setup.bash
  source ${parent.bintools}/nix-support/add-flags.sh
  source ${parent}/nix-support/add-flags.sh
  export PATH="$path_backup"
  wrapperRun toolchain "$@"
  EOF
  cp ${./cc-main.c} 'operation source.c'
  for entry in compiler fresh; do
    policy=1
    receiver=(${child}/nix-support/compiler ${rawCC})
    if [[ $entry == fresh ]]; then
      policy=2
      receiver=(${child}/bin/${targetPrefix}cc)
    fi
    # The adapter, rather than its parent, expands this response file. A path
    # with spaces also exercises the wrapper's own output response file.
    printf '%q\n' "$PWD/operation source.c" -include ${./operation-policy.h} \
      -DEXPECTED_POLICY="$policy" -DEXPECTED_RAW=0 -DEXPECTED_ROLE=0 \
      -o "$PWD/entry-$entry" > 'operation input.rsp'
    env -u NIX_CFLAGS_COMPILE_${suffixSalt} NIX_CFLAGS_COMPILE= \
      NIX_CC_USE_RESPONSE_FILE=1 NIX_LD_USE_RESPONSE_FILE=1 \
      "$BASH" ./prepare-operation "''${receiver[@]}" '@operation input.rsp'
    ${emulator} ./entry-$entry
  done

  # Selected defaults remain independent of C++ rendering. A C parent can
  # delegate to an actual C++ compiler without omitting or duplicating its SDK.
  printf '%q\n' ${./cxx-main.cc} -include ${./operation-policy.h} \
    -DEXPECTED_POLICY=1 -DEXPECTED_RAW=0 -DEXPECTED_ROLE=0 \
    -o "$PWD/entry-cxx" > 'operation cxx.rsp'
  env -u NIX_CFLAGS_COMPILE_${suffixSalt} NIX_CFLAGS_COMPILE= \
    NIX_CC_USE_RESPONSE_FILE=1 NIX_LD_USE_RESPONSE_FILE=1 \
    "$BASH" ./prepare-operation ${child}/nix-support/compiler ${rawCXX} \
    '@operation cxx.rsp'
  ${emulator} ./entry-cxx

  ${lib.optionalString stdenv.cc.isClang ''
    # Swift's actual link job uses clang --driver-mode=g++, not necessarily a
    # compiler whose basename ends in ++.
    env -u NIX_CFLAGS_COMPILE_${suffixSalt} NIX_CFLAGS_COMPILE= \
    "$BASH" ./prepare-operation ${child}/nix-support/compiler ${rawCC} \
      --driver-mode=g++ '@operation cxx.rsp'
    ${emulator} ./entry-cxx
    for order in language-first mode-first; do
      flags=(-x c++ --driver-mode=gcc)
      if [[ $order == mode-first ]]; then flags=(--driver-mode=gcc -x c++); fi
      env -u NIX_CFLAGS_COMPILE_${suffixSalt} NIX_CFLAGS_COMPILE= \
        "$BASH" ./prepare-operation ${child}/nix-support/compiler ${rawCC} \
        "''${flags[@]}" '@operation cxx.rsp' -c -o operation-cxx.o
      # Explicit GCC driver mode does not promise implicit C++ runtime linkage.
      "$BASH" ./prepare-operation ${child}/nix-support/compiler ${rawCXX} \
        operation-cxx.o -o entry-cxx
      ${emulator} ./entry-cxx
    done
  ''}

  echo "checking terminal include suppression preserves explicit caller paths..." >&2
  cat > operation-header.c <<'EOF'
  #include <operation-header.h>
  int main(void) { return OPERATION_HEADER != 42; }
  EOF
  for mode in nostdinc no-libc; do
    flags=()
    include=0
    if [[ $mode == nostdinc ]]; then flags=(-nostdinc); include=1; fi
    if env -u NIX_CFLAGS_COMPILE_${suffixSalt} NIX_CFLAGS_COMPILE= \
      WRAPPER_TEST_C_INCLUDE="$include" \
      "$BASH" ./prepare-operation ${child}/nix-support/compiler ${rawCC} \
      "''${flags[@]}" -c operation-header.c -o operation-header.o > "$mode.log" 2>&1; then
      echo "The suppressed default header was found in $mode mode" >&2
      exit 1
    fi
    grep -F 'operation-header.h' "$mode.log"
  done
  # This is deliberately the identical path to the suppressed default.
  env NIX_CFLAGS_COMPILE_${suffixSalt}='-isystem ${parent}/nix-support/operation-include' \
    NIX_CFLAGS_COMPILE= \
    "$BASH" ./prepare-operation ${child}/nix-support/compiler ${rawCC} \
    -nostdinc operation-header.c -o operation-header
  ${emulator} ./operation-header

  ${lib.optionalString stdenv.hostPlatform.isLinux ''
    echo "checking main linker flags precede implicit runtime libraries..." >&2
    cat > operation-library.c <<'EOF'
    #include <stdio.h>
    int operation(void) { return puts("archive linked before libc") < 0; }
    EOF
    cat > operation-main.c <<'EOF'
    int operation(void);
    int main(void) { return operation(); }
    EOF
    ${CC} -fPIC -c operation-library.c -o operation-library.o
    $AR rcs liboperation.a operation-library.o
    # Whole-archive also makes duplicate forwarding fail with duplicate symbols.
    NIX_LDFLAGS="-L$PWD --whole-archive -loperation --no-whole-archive" \
      NIX_CC_USE_RESPONSE_FILE=1 NIX_LD_USE_RESPONSE_FILE=1 \
      ${CC} ${staticLibc} -static operation-main.c -o operation-static
    ${emulator} ./operation-static

    echo "checking the prepared terminal linker renders selected libraries..." >&2
    # A distinct output name keeps -loperation from finding its own output.
    NIX_LDFLAGS="-L$PWD --whole-archive -loperation --no-whole-archive" \
      NIX_LD_USE_RESPONSE_FILE=1 \
      "$BASH" ./prepare-operation ${child.bintools}/nix-support/linker ${rawLD} \
      -shared -o liboperation-shared.so
    NIX_LDFLAGS="-L$PWD -rpath $PWD" \
      ${CC} operation-main.c -loperation-shared -o operation-shared
    ${emulator} ./operation-shared
  ''}
''
