{
  lib,
  stdenv,
  CC,
  emulator,
  staticLibc,
}:
let
  # A hook can introduce a link after the initial compile-only decision.
  lateCC = stdenv.cc.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      cat > "$out/nix-support/cc-wrapper-hook" <<'EOF'
      if [[ ''${NIX_TEST_LATE_START_LINK:-} == 1 ]]; then
          lateParams=()
          for arg in "''${params[@]}"; do
              [[ $arg == -c ]] || lateParams+=("$arg")
          done
          params=("''${lateParams[@]}" -shared)
      fi
      EOF
    '';
  });
  lateCompiler = lib.getExe' lateCC "${stdenv.cc.targetPrefix}cc";
in
lib.optionalString (stdenv.hostPlatform.isLinux && !stdenv.hostPlatform.isStatic) ''
  echo 'checking linker option operands and RPATH spellings' >&2
  (
    source ${../../build-support/wrapper-common/utils.bash}
    wrapperLinkerFlavor=bfd
    [[ $(filterRpathFlags dynamic -n -L/kept) == '-n -L/kept' ]]
    [[ $(IFS=: filterRpathFlags dynamic -e policy_entry) == '-e policy_entry' ]]
    [[ $(IFS=: filterCompilerRpathFlags dynamic -e policy_entry) == '-e policy_entry' ]]
    [[ $(filterRpathFlags static-pie --output -rpath --rpath=/removed -rpath=/removed --rpath /removed -rpath /removed -lkeep) == '--output -rpath -lkeep' ]]
  )

  # A real dynamic input ensures GNU ld emits an interpreter to inspect.
  printf 'void policy_entry(void) {}\n' > linker-policy.c
  ${CC} -fPIC -c linker-policy.c -o linker-policy.o
  LD=${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}ld
  READELF=${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}readelf

  # Serializing retained flags must not interpret a leading -e as echo's
  # option, including when removing an RPATH exposes it at the front.
  env NIX_LDFLAGS_BEFORE='-e policy_entry' \
    "$LD" linker-policy.o -o linker-policy-entry
  env NIX_LDFLAGS_BEFORE='--rpath=/removed -e policy_entry' \
    ${CC} -nostdlib -static-pie linker-policy.o -o linker-policy-entry-pie

  # A linker operand beginning with -L must not become a compiler search path.
  for channel in NIX_LDFLAGS_BEFORE NIX_LDFLAGS NIX_LDFLAGS_AFTER; do
    env "$channel=--soname -L/soname-policy -rpath -L/rpath-policy" \
      ${CC} -shared linker-policy.o -o linker-policy-operands.so
    "$READELF" -d linker-policy-operands.so > linker-policy.dynamic
    grep -F -- '-L/soname-policy' linker-policy.dynamic
    grep -F -- '-L/rpath-policy' linker-policy.dynamic
  done

  ${lib.optionalString stdenv.cc.isGNU ''
    # Compiler-visible -L must precede search paths introduced by -B.
    mkdir -p linker-policy-search/{prefix,selected}
    printf 'int policy_library(void) { return 11; }\n' > linker-policy-search/prefix/library.c
    printf 'int policy_library(void) { return 22; }\n' > linker-policy-search/selected/library.c
    for dir in prefix selected; do
      ${CC} -c linker-policy-search/$dir/library.c -o linker-policy-search/$dir/library.o
      $AR rcs linker-policy-search/$dir/libpolicy.a linker-policy-search/$dir/library.o
    done
    printf 'extern int policy_library(void); int main(void) { return policy_library() != 22; }\n' \
      > linker-policy-search/main.c
    NIX_LDFLAGS="-L$PWD/linker-policy-search/selected" \
      ${CC} -B"$PWD/linker-policy-search/prefix/" linker-policy-search/main.c -lpolicy -o linker-policy-search/main
    ${emulator} ./linker-policy-search/main
  ''}

  ${lib.optionalString (stdenv.cc.isGNU || stdenv.cc.isClang) ''
    echo 'checking unrendered linker inputs in compiler subprocesses' >&2
    mkdir independent-linker
    printf 'int independent(void) { return 7; }\n' > independent-linker/library.c
    printf 'extern int independent(void); int use(void) { return independent(); }\n' > independent-linker/use.c
    ${CC} -c independent-linker/library.c -o independent-linker/library.o
    ${CC} -c independent-linker/use.c -o independent-linker/use.o
    $AR rcs independent-linker/libindependent.a independent-linker/library.o
    cat > independent-linker/launch <<'EOF'
    #!${stdenv.shell}
    if [[ ! -e independent-linker/status ]]; then
        (
          if [[ ''${NIX_TEST_INDEPENDENT_FRESH:-} == 1 ]]; then
            unset NIX_WRAPPER_OPERATION
            unset NIX_BINTOOLS_WRAPPER_TARGET_HOST_${stdenv.cc.bintools.suffixSalt}
            unset NIX_BINTOOLS_WRAPPER_TARGET_TARGET_${stdenv.cc.bintools.suffixSalt}
            export NIX_BINTOOLS_WRAPPER_TARGET_BUILD_${stdenv.cc.bintools.suffixSalt}=1
          fi
          ${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}ld -r \
            independent-linker/use.o -lindependent -o independent-linker/linked.o
        ) 2> independent-linker/stderr
        echo $? > independent-linker/status
    fi
    ${
      if stdenv.cc.isGNU then
        ''exec "$@"''
      else
        ''exec ${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}as "$@"''
    }
    EOF
    chmod +x independent-linker/launch
    launch=()
    ${
      if stdenv.cc.isGNU then
        ''launch=(-wrapper "$PWD/independent-linker/launch")''
      else
        ''
          if [[ -x ${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}as ]]; then
            ln -s launch independent-linker/as
            launch=(-fno-integrated-as -B"$PWD/independent-linker/")
          fi
        ''
    }
    if (( ''${#launch[@]} )); then
      for inheritedType in unset dynamic static-pie; do
        rm -f independent-linker/status
        (
          unset linkType
          [[ $inheritedType == unset ]] || export linkType=$inheritedType
          NIX_LDFLAGS="-L$PWD/independent-linker" \
            ${CC} "''${launch[@]}" -c ${./cc-main.c} -o independent-linker/outer.o
        )
        if [[ $(cat independent-linker/status) != 0 ]]; then
          cat independent-linker/stderr >&2
          exit 1
        fi
      done

      # An independent linker under a full link needs an explicit fresh
      # boundary. Its role change must affect the child, preserving the outer
      # driver's link continuation and selected inputs.
      mkdir independent-linker/build
      printf 'int independent(void) { return 13; } int build_role(void) { return 1; }\n' \
        > independent-linker/build/library.c
      ${CC} -c independent-linker/build/library.c -o independent-linker/build/library.o
      $AR rcs independent-linker/build/libindependent.a independent-linker/build/library.o
      rm independent-linker/status
      (
        unset NIX_CC_WRAPPER_TARGET_BUILD_${stdenv.cc.suffixSalt}
        unset NIX_CC_WRAPPER_TARGET_TARGET_${stdenv.cc.suffixSalt}
        export NIX_CC_WRAPPER_TARGET_HOST_${stdenv.cc.suffixSalt}=1
        NIX_TEST_INDEPENDENT_FRESH=1 NIX_LDFLAGS="-L$PWD/independent-linker" \
          NIX_LDFLAGS_FOR_BUILD="-L$PWD/independent-linker/build" \
          ${CC} "''${launch[@]}" ${./cc-main.c} \
            -Wl,--whole-archive,-lindependent,--no-whole-archive -o independent-linker/outer
      )
      if [[ $(cat independent-linker/status) != 0 ]]; then
        cat independent-linker/stderr >&2
        exit 1
      fi
      "$READELF" -sW independent-linker/linked.o | grep -q ' build_role$'
      if "$READELF" -sW independent-linker/outer | grep -q ' build_role$'; then exit 1; fi
    fi

    echo 'checking a late link renders selected linker inputs' >&2
    NIX_TEST_LATE_START_LINK=1 NIX_LDFLAGS="-rpath $PWD/independent-linker" \
      PATH= ${lateCompiler} -c ${./cc-main.c} -o independent-linker/late.so
    "$READELF" -d independent-linker/late.so > independent-linker/dynamic
    grep -F "$PWD/independent-linker" independent-linker/dynamic
  ''}

  "$LD" -shared linker-policy.o -o liblinker-policy.so
  # GNU ld accepts output mode overrides; LLD rejects shared+pie together.
  isGNULinker=0
  if "$LD" --version | grep -q 'GNU ld'; then
    isGNULinker=1
    for mode in '-shared -pie' '-shared -no-pie'; do
      env NIX_DYNAMIC_LINKER_${stdenv.cc.bintools.suffixSalt}=/selected/wrapper-loader \
        "$LD" -e policy_entry linker-policy.o ./liblinker-policy.so $mode -o linker-policy-dynamic
      "$READELF" -l linker-policy-dynamic > linker-policy.headers
      grep -Fq '/selected/wrapper-loader' linker-policy.headers
    done
  fi
  # A trailing -Bstatic controls only subsequent input searches. Both explicit
  # and searched DSOs selected earlier still need the chosen interpreter.
  printf 'INPUT(%s/liblinker-policy.so)\n' "$PWD" > linker-policy-script.ld
  for input in './liblinker-policy.so' '-L. -llinker-policy' 'linker-policy-script.ld'; do
    env NIX_DYNAMIC_LINKER_${stdenv.cc.bintools.suffixSalt}=/selected/wrapper-loader \
      "$LD" -e policy_entry linker-policy.o $input -Bstatic -o linker-policy-dynamic
    "$READELF" -l linker-policy-dynamic > linker-policy.headers
    grep -Fq '/selected/wrapper-loader' linker-policy.headers
  done

  ${lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    rpaths=('-rpath /nix/store/unused-policy' '--rpath /nix/store/unused-policy' \
        '-rpath=/nix/store/unused-policy' '--rpath=/nix/store/unused-policy')
    for rpath in "''${rpaths[@]}"; do
      NIX_LDFLAGS="$rpath" ${CC} ${staticLibc} -static-pie ${./cc-main.c} -o linker-policy-pie
      "$READELF" -ld linker-policy-pie > linker-policy.headers
      if grep -E 'RPATH|RUNPATH|INTERP' linker-policy.headers; then exit 1; fi
      ${emulator} ./linker-policy-pie
    done

    # -oformat is joined -o format, so the following RPATH remains an option.
    NIX_LDFLAGS='-oformat --rpath /nix/store/unused-policy -o linker-policy-oformat' \
      ${CC} ${staticLibc} -static-pie ${./cc-main.c} -o linker-policy-oformat
    "$READELF" -ld linker-policy-oformat > linker-policy.headers
    if grep -E 'RPATH|RUNPATH|INTERP' linker-policy.headers; then exit 1; fi
    ${emulator} ./linker-policy-oformat

    if [[ -x ${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ld.gold ]]; then
      (
        source ${../../build-support/wrapper-common/utils.bash}
        # The compiler's declared flavor need not match its selected linker.
        wrapperLinkerFlavor=bfd
        symbolFlags=($(filterRpathFlags static-pie --just-symbols "$PWD/policy-missing-symbols.o"))
        if ${stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ld.gold \
          -shared linker-policy.o "''${symbolFlags[@]}" -o linker-policy-gold \
          2> linker-policy-gold.stderr; then
          echo 'gold accepted a missing symbol input' >&2
          exit 1
        fi
        grep -F 'policy-missing-symbols.o' linker-policy-gold.stderr
      )
    fi

    # Compiler option operands are not raw linker aliases.
    printf '#define POLICY_HEADER 1\n' > -Rpolicy-header.h
    printf '#ifndef POLICY_HEADER\n#error missing header\n#endif\nint main(void) { return 0; }\n' > linker-policy-header.c
    NIX_CFLAGS_LINK='-include -Rpolicy-header.h -pthread' \
      ${CC} ${staticLibc} -static-pie linker-policy-header.c -o linker-policy-header
    ${emulator} ./linker-policy-header

    # -R/--just-symbols on an existing object imports symbols instead of
    # setting RPATH. Filtering those operands would silently lose symbols.
    printf 'int policy_external = 42;\n' > linker-policy-symbols.c
    ${CC} -c linker-policy-symbols.c -o linker-policy-symbols.o
    printf 'extern int policy_external; int main(void) { return policy_external; }\n' > linker-policy-reference.c
    symbolFlags=("--just-symbols $PWD/linker-policy-symbols.o" "--just-symbols=$PWD/linker-policy-symbols.o")
    if [[ $isGNULinker == 1 ]]; then
      symbolFlags+=("-R $PWD/linker-policy-symbols.o" "-R$PWD/linker-policy-symbols.o")
    fi
    for symbols in "''${symbolFlags[@]}"; do
      NIX_LDFLAGS="$symbols" \
        ${CC} ${staticLibc} -static-pie linker-policy-reference.c -o linker-policy-symbols
      "$READELF" -s linker-policy-symbols > linker-policy.symbols
      grep -q 'policy_external' linker-policy.symbols
    done
  ''}
''
