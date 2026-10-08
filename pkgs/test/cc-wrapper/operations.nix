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
      ${lib.optionalString stdenv.cc.isClang ''
        mkdir -p "$out/nix-support/operation-cxx-include"
        echo '#define PACKAGED_CXX_HEADER 42' > "$out/nix-support/operation-cxx-include/packaged-cxx-header.h"
        echo " -cxx-isystem $out/nix-support/operation-cxx-include" >> "$out/nix-support/libcxx-cxxflags"
      ''}
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
  ppcHeaders = stdenv.mkDerivation {
    name = "cc-wrapper-header-provider";
    buildCommand = ''
      mkdir -p "$out/include"
      echo '#define SELECTED_PROVIDER 731' > "$out/include/selected-provider.h"
    '';
  };
  # Preprocessing needs only a header provider, not a foreign libc or linker.
  ppcCompilers =
    map
      (
        abi:
        stdenv.cc.override (
          old:
          let
            libc = old.libc // {
              dev = ppcHeaders;
            };
          in
          {
            stdenvNoCC = old.stdenvNoCC // {
              targetPlatform = lib.systems.elaborate "powerpc64-unknown-linux-gnuabielfv${abi}";
            };
            inherit libc;
            bintools = old.bintools.override { inherit libc; };
            libcxx = null;
            gccForLibs = null;
            includeFortifyHeaders = false;
          }
        )
      )
      [
        "1"
        "2"
      ];
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

  echo "checking driver personality independently of per-input language..." >&2
  cat > driver-language.c <<'EOF'
  #ifdef __cplusplus
  #error Expected a C input
  #endif
  #if defined(DRIVER_CXX_POLICY) != EXPECT_DRIVER_CXX_POLICY
  #error Wrong driver policy
  #endif
  int main(void) { return 0; }
  EOF
  cat > driver-language.cc <<'EOF'
  #ifndef __cplusplus
  #error Expected a C++ input
  #endif
  #include <vector>
  #if defined(DRIVER_CXX_POLICY) != EXPECT_DRIVER_CXX_POLICY
  #error Wrong driver policy
  #endif
  std::vector<int> values;
  EOF
  # -x is stateful per input, including reset to extension-based selection.
  # Opaque caller flags are global driver policy, not per-input C++ options.
  for driver in cc c++; do
    expected=0
    if [[ $driver == c++ ]]; then expected=1; fi
    NIX_CXXSTDLIB_COMPILE=-DDRIVER_CXX_POLICY=1 \
      ${parent}/bin/${targetPrefix}"$driver" -fsyntax-only \
      -DEXPECT_DRIVER_CXX_POLICY="$expected" \
      -x c++ driver-language.cc -x c driver-language.c
    NIX_CXXSTDLIB_COMPILE=-DDRIVER_CXX_POLICY=1 \
      ${parent}/bin/${targetPrefix}"$driver" -fsyntax-only \
      -DEXPECT_DRIVER_CXX_POLICY="$expected" \
      -x c++ -x c driver-language.c -x none driver-language.cc
  done
  # A C driver does not acquire C++ runtime policy from an earlier -x c++;
  # a C++ driver retains it even when all inputs are explicitly C.
  NIX_CXXSTDLIB_LINK=-lmissing_driver_policy \
    ${parent}/bin/${targetPrefix}cc -DEXPECT_DRIVER_CXX_POLICY=0 \
    -x c++ -x c driver-language.c -o driver-language
  ${emulator} ./driver-language
  if NIX_CXXSTDLIB_LINK=-lmissing_driver_policy \
    ${parent}/bin/${targetPrefix}c++ -DEXPECT_DRIVER_CXX_POLICY=0 \
    -x c driver-language.c -o driver-language > driver-language.log 2>&1; then
    echo "C++ driver lost its runtime policy for a C input" >&2
    exit 1
  fi
  grep -F missing_driver_policy driver-language.log

  # Suppressing default headers/libraries does not suppress explicit policy.
  cat > explicit-policy.cc <<'EOF'
  #ifndef EXPLICIT_CXX_POLICY
  #error explicit C++ policy was suppressed
  #endif
  static_assert(__cplusplus >= 201703L);
  EOF
  for suppression in -nostdinc -nostdinc++; do
    NIX_CXXSTDLIB_COMPILE='-std=c++17 -DEXPLICIT_CXX_POLICY=1' \
      ${parent}/bin/${targetPrefix}c++ "$suppression" -c explicit-policy.cc -o explicit-policy.o
  done
  ${lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir explicit-policy
    echo 'int explicit_value(void) { return 42; }' > explicit-policy/value.c
    ${CC} -fPIC -c explicit-policy/value.c -o explicit-policy/value.o
    $AR crs explicit-policy/libexplicit.a explicit-policy/value.o
    cat > explicit-policy/link.cc <<'EOF'
    extern "C" int explicit_value(void);
    int entry() { return explicit_value(); }
    EOF
    if ${parent}/bin/${targetPrefix}c++ -shared -fPIC -nostdlib -Wl,--no-undefined \
      explicit-policy/link.cc -o explicit-policy/missing.so > explicit-policy/missing.log 2>&1; then
      echo "A missing explicit library unexpectedly linked" >&2
      exit 1
    fi
    grep -F explicit_value explicit-policy/missing.log
    NIX_CXXSTDLIB_LINK="-L$PWD/explicit-policy -lexplicit" \
      ${parent}/bin/${targetPrefix}c++ -shared -fPIC -nostdlib -Wl,--no-undefined \
      explicit-policy/link.cc -o explicit-policy/linked.so
    echo 'void *operator new(__SIZE_TYPE__); void *entry() { return ::operator new(1); }' \
      > explicit-policy/default-runtime.cc
    ${parent}/bin/${targetPrefix}c++ -shared -fPIC -Wl,--no-undefined \
      explicit-policy/default-runtime.cc -o explicit-policy/default-runtime.so
    if ${parent}/bin/${targetPrefix}c++ -shared -fPIC -nostdlib -Wl,--no-undefined \
      explicit-policy/default-runtime.cc -o explicit-policy/suppressed.so > explicit-policy/default.log 2>&1; then
      echo "The suppressed C++ runtime unexpectedly linked" >&2
      exit 1
    fi
    grep -F 'operator new' explicit-policy/default.log
  ''}

  # Unlike GCC, Clang selects mode before parsing even option operands.
  touch -- --driver-mode=g++
  NIX_CXXSTDLIB_COMPILE=-DDRIVER_CXX_POLICY=1 \
    ${parent}/bin/${targetPrefix}cc -include --driver-mode=g++ \
    -x c -c driver-language.c -DEXPECT_DRIVER_CXX_POLICY=${if stdenv.cc.isClang then "1" else "0"} \
    -o driver-language.o

  ${lib.optionalString stdenv.cc.isClang ''
    # Its global scan also sees tokens after --, after our generic arguments.
    NIX_CFLAGS_COMPILE=--driver-mode=gcc NIX_CXXSTDLIB_COMPILE=-DDRIVER_CXX_POLICY=1 \
      ${parent}/bin/${targetPrefix}cc -x c -c driver-language.c \
      -DEXPECT_DRIVER_CXX_POLICY=1 -x none -- --driver-mode=g++

    # Generic argument channels take effect in their actual BEFORE/AFTER
    # order. Conditional C++ flags are selected only after that primary mode.
    for channel in NIX_CFLAGS_COMPILE_BEFORE NIX_CFLAGS_COMPILE; do
      for mode in gcc g++; do
        expected=0
        if [[ $mode == g++ ]]; then expected=1; fi
        cliMode=gcc
        if [[ $channel == NIX_CFLAGS_COMPILE_BEFORE ]]; then
          cliMode=g++
          expected=1
        fi
        env "$channel=--driver-mode=$mode" NIX_CXXSTDLIB_COMPILE=-DDRIVER_CXX_POLICY=1 \
          ${parent}/bin/${targetPrefix}cc --driver-mode="$cliMode" \
          -x c driver-language.c -fsyntax-only -DEXPECT_DRIVER_CXX_POLICY="$expected"
      done
    done

    if NIX_CFLAGS_LINK=--driver-mode=g++ NIX_CXXSTDLIB_LINK=-lmissing_driver_policy \
      ${parent}/bin/${targetPrefix}cc -x c driver-language.c \
      -DEXPECT_DRIVER_CXX_POLICY=0 -o driver-language > driver-mode-link.log 2>&1; then
      echo "Generic link arguments did not select C++ runtime policy" >&2
      exit 1
    fi
    grep -F missing_driver_policy driver-mode-link.log

    # The C driver needs packaged C++ headers without opaque caller flags,
    # including when a different receiver interprets the prepared request.
    echo '#include <packaged-cxx-header.h>' > packaged-header.cc
    echo 'static_assert(PACKAGED_CXX_HEADER == 42);' >> packaged-header.cc
    NIX_CXXSTDLIB_COMPILE=-std=c++17 \
      "$BASH" ./prepare-operation ${child}/nix-support/compiler ${rawCC} \
      -fsyntax-only -DEXPECT_DRIVER_CXX_POLICY=0 \
      -x c driver-language.c -x c++ packaged-header.cc

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

  ${lib.optionalString (stdenv.cc.isGNU && (stdenv.cc.cc.nativeDefaultIncludeBinding or null) != null)
    ''
      cat > default-c-header.c <<'EOF'
      #include <stdio.h>
      int main(void) { return 0; }
      EOF
      for suppression in -Wp,-nostdinc -Xpreprocessor; do
        flags=("$suppression")
        if [[ $suppression == -Xpreprocessor ]]; then flags+=(-nostdinc); fi
        if NIX_CFLAGS_COMPILE= "$BASH" ./prepare-operation \
          ${parent}/nix-support/compiler ${rawCC} \
          "''${flags[@]}" -c default-c-header.c -o default-c-header.o \
          > default-c-header.log 2>&1; then
          echo "A forwarded -nostdinc retained the selected libc headers" >&2
          exit 1
        fi
        grep -F 'stdio.h' default-c-header.log
      done

      cat > default-cxx-header.cc <<'EOF'
      #include <vector>
      int main() { return 0; }
      EOF
      if NIX_CFLAGS_COMPILE= "$BASH" ./prepare-operation \
        ${parent}/nix-support/compiler ${rawCXX} \
        -Wp,-nostdinc++ -c default-cxx-header.cc -o default-cxx-header.o \
        > default-cxx-header.log 2>&1; then
        echo "A forwarded -nostdinc++ retained the selected C++ headers" >&2
        exit 1
      fi
      grep -F 'vector' default-cxx-header.log
    ''
  }

  ${lib.optionalString ((stdenv.cc.cc.nativeDefaultIncludeBinding or null) == "driver") ''
    ${lib.optionalString (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid) ''
      # The configured ABI lives in -mabi; its map must use the same target
      # spelling as the driver. Exercise real wrapper generation for both ABIs.
      cat > selected-provider.c <<'EOF'
      #include <selected-provider.h>
      #if _CALL_ELF != EXPECTED_ABI
      #error Wrong PowerPC ABI
      #endif
      SELECTED_PROVIDER
      EOF
      ${lib.concatImapStringsSep "\n" (abi: compiler: ''
        env -i ${compiler}/bin/${compiler.targetPrefix}cc \
          -DEXPECTED_ABI=${toString abi} -E -P selected-provider.c > selected-provider.out
        [[ $(cat selected-provider.out) == 731 ]]
      '') ppcCompilers}
    ''}

    cat > no-default-header.c <<'EOF'
    int main(void) { return 0; }
    EOF
    NIX_CFLAGS_COMPILE= "$BASH" ./prepare-operation \
      ${parent}/nix-support/compiler ${rawCC} \
      -nostdinc -Werror=unused-command-line-argument \
      -c no-default-header.c -o no-default-header.o

    cat > default-c-header.c <<'EOF'
    #include <stdio.h>
    int main(void) { return 0; }
    EOF
    for suppression in -nostdinc -nostdlibinc; do
      if NIX_CFLAGS_COMPILE= "$BASH" ./prepare-operation \
        ${parent}/nix-support/compiler ${rawCC} \
        "$suppression" -c default-c-header.c -o default-c-header.o \
        > default-c-header.log 2>&1; then
        echo "Clang retained selected libc headers with $suppression" >&2
        exit 1
      fi
      grep -F 'stdio.h' default-c-header.log
    done

    cat > default-cxx-header.cc <<'EOF'
    #include <vector>
    int main() { return 0; }
    EOF
    if NIX_CFLAGS_COMPILE= "$BASH" ./prepare-operation \
      ${parent}/nix-support/compiler ${rawCXX} \
      -nostdinc++ -c default-cxx-header.cc -o default-cxx-header.o \
      > default-cxx-header.log 2>&1; then
      echo "Clang retained selected C++ headers with -nostdinc++" >&2
      exit 1
    fi
    grep -F 'vector' default-cxx-header.log

    ${lib.optionalString
      (
        stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isAndroid && (stdenv.cc.libcxx.isLLVM or false)
      )
      ''
        for mode in -E -c; do
          NIX_CFLAGS_COMPILE= "$BASH" ./prepare-operation \
            ${parent}/nix-support/compiler ${rawCC} \
            -Werror=unused-command-line-argument \
            "$mode" no-default-header.c -o no-default-header.o
        done
        # The selected libc++ is a default, not an override of the actual job.
        # This map has no libstdc++ provider, so selecting it must find no vector.
        for entry in fresh prepared; do
          compiler=(${parent}/bin/${targetPrefix}c++)
          if [[ $entry == prepared ]]; then
            compiler=("$BASH" ./prepare-operation ${parent}/nix-support/compiler ${rawCXX})
          fi
          NIX_CFLAGS_COMPILE= "''${compiler[@]}" -stdlib=libc++ \
            -E default-cxx-header.cc -o default-cxx-header.i
          if NIX_CFLAGS_COMPILE= "''${compiler[@]}" -stdlib=libstdc++ \
            -E default-cxx-header.cc -o default-cxx-header.i \
            > default-cxx-header.log 2>&1; then
            echo "Clang replaced the caller's standard-library selection" >&2
            exit 1
          fi
          grep -F 'vector' default-cxx-header.log
        done
      ''
    }
  ''}

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
