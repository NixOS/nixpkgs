{
  lib,
  stdenv,
  CC,
  emulator,
  staticLibc,
}:
let
  # This hook runs after generic compiler observation. Only the actual linker
  # continuation can correct the policy for the mode it introduces.
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
      if [[ ''${NIX_TEST_LATE_STATIC_PIE:-} == 1 && $dontLink != 1 ]]; then
          extraAfter+=(-static-pie)
          # A hook's scratch variable is not the compiler's rendering history.
          linkType=static-pie
          touch linker-policy-late-hook-ran
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
    wrapperLinkerIsLLVM=0
    for option in -o --output -rpath --rpath -rpath-link --rpath-link \
        -e --entry --script --soname --version-script --dynamic-list --wrap \
        --init --fini --require-defined --export-dynamic-symbol; do
      [[ $(checkLinkerLinkType "$option" -static) == dynamic ]]
      [[ $(checkLinkerLinkType "$option" --no-dynamic-linker -pie) == dynamic ]]
      [[ $(checkLinkerLinkType "$option" -shared -static) == static ]]
    done
    [[ $(checkLinkerLinkType --build-id -static) == static ]]
    [[ $(checkLinkerLinkType -Bstatic -pie --no-dynamic-linker) == static-pie ]]
    [[ $(checkLinkerLinkType --push-state -Bstatic --pop-state) == dynamic ]]
    [[ $(checkLinkerLinkType --shared) == shared ]]
    [[ $(checkLinkerLinkType -shared -pie) == dynamic ]]
    [[ $(checkLinkerLinkType -shared -no-pie) == dynamic ]]
    [[ $(checkLinkerLinkType -pie -shared) == shared ]]
    [[ $(checkLinkerLinkType -shared -pie --no-dynamic-linker) == static-pie ]]
    [[ $(checkLinkerLinkType libinput.so -Bstatic) == dynamic ]]
    [[ $(checkLinkerLinkType -linput -Bstatic) == dynamic ]]
    [[ $(checkLinkerLinkType --library input -Bstatic) == dynamic ]]
    [[ $(checkLinkerLinkType -Bstatic -linput) == static ]]
    [[ $(checkLinkerLinkType -l:libinput.a -Bstatic) == static ]]
    [[ $(checkLinkerLinkType --library=:libinput.a -Bstatic) == static ]]
    [[ $(checkLinkerLinkType -library=:libinput.a -Bstatic) == dynamic ]]
    [[ $(checkLinkerLinkType -library -shared) == shared ]]
    [[ $(checkLinkerLinkType -library-path -shared) == shared ]]
    [[ $(checkLinkerLinkType -output -shared) == shared ]]
    (
      wrapperLinkerIsLLVM=1
      [[ $(checkLinkerLinkType -library=:libinput.a -Bstatic) == static ]]
      [[ $(checkLinkerLinkType -library -shared) == dynamic ]]
      [[ $(checkLinkerLinkType -library-path -shared) == dynamic ]]
      [[ $(checkLinkerLinkType -output -shared) == shared ]]
    )
    [[ $(filterRpathFlags static-pie --output -rpath --rpath=/removed -rpath=/removed --rpath /removed -rpath /removed -lkeep) == '--output -rpath -lkeep' ]]
  )

  # The long output option consumes its next argument, even a mode spelling.
  # A real dynamic input ensures GNU ld emits an interpreter to inspect.
  printf 'void policy_entry(void) {}\n' > linker-policy.c
  ${CC} -fPIC -c linker-policy.c -o linker-policy.o
  LD=${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}ld
  READELF=${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}readelf

  # A linker operand beginning with -L must not become a compiler search path.
  for channel in NIX_LDFLAGS_BEFORE NIX_LDFLAGS NIX_LDFLAGS_AFTER; do
    env "$channel=--soname -L/soname-policy -rpath -L/rpath-policy" \
      ${CC} -shared linker-policy.o -o linker-policy-operands.so
    "$READELF" -d linker-policy-operands.so > linker-policy.dynamic
    grep -F -- '-L/soname-policy' linker-policy.dynamic
    grep -F -- '-L/rpath-policy' linker-policy.dynamic
  done

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
  env NIX_DYNAMIC_LINKER_${stdenv.cc.bintools.suffixSalt}=/selected/wrapper-loader \
    "$LD" --output -static -e policy_entry linker-policy.o -L. -llinker-policy
  "$READELF" -l ./-static > linker-policy.headers
  grep -Fq '/selected/wrapper-loader' linker-policy.headers

  # -output is the joined short option -o utput, leaving -pie as an option.
  # Mistaking it for --output retains incompatible static-PIE RPATH policy.
  NIX_LDFLAGS='-rpath /nix/store/unused-policy' \
    "$LD" -output -pie --no-dynamic-linker -e policy_entry linker-policy.o -o linker-policy-short-output
  "$READELF" -ld linker-policy-short-output > linker-policy.headers
  if grep -E 'RPATH|RUNPATH|INTERP' linker-policy.headers; then exit 1; fi

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
  for input in './liblinker-policy.so' '-L. -llinker-policy'; do
    env NIX_DYNAMIC_LINKER_${stdenv.cc.bintools.suffixSalt}=/selected/wrapper-loader \
      "$LD" -e policy_entry linker-policy.o $input -Bstatic -o linker-policy-dynamic
    "$READELF" -l linker-policy-dynamic > linker-policy.headers
    grep -Fq '/selected/wrapper-loader' linker-policy.headers
  done

  # Fresh main and trailing policy are part of actual linker argv too.
  for channel in NIX_LDFLAGS_BEFORE NIX_LDFLAGS NIX_LDFLAGS_AFTER; do
    env "$channel=-static -pie --no-dynamic-linker -rpath /nix/store/unused-policy" \
      "$LD" -e policy_entry linker-policy.o -o linker-policy-direct-pie
    "$READELF" -ld linker-policy-direct-pie > linker-policy.headers
    grep -q 'FLAGS_1.*PIE' linker-policy.headers
    if grep -E 'RPATH|RUNPATH|INTERP' linker-policy.headers; then exit 1; fi
  done

  ${lib.optionalString (stdenv.hostPlatform.libc == "glibc") ''
    rpaths=('-rpath /nix/store/unused-policy' '--rpath /nix/store/unused-policy' \
        '-rpath=/nix/store/unused-policy' '--rpath=/nix/store/unused-policy' \
        '-R /nix/store/unused-policy' '-R/nix/store/unused-policy')
    if [[ $isGNULinker == 1 ]]; then
      rpaths+=('--just-symbols /nix/store/unused-policy' '--just-symbols=/nix/store/unused-policy' \
        '-just-symbols=/nix/store/unused-policy')
    fi
    for rpath in "''${rpaths[@]}"; do
      # Both visible and opaque link policy must produce runnable static PIEs.
      for source in visible opaque late; do
        flags=(-static-pie)
        compiler=${lib.getExe' stdenv.cc "${stdenv.cc.targetPrefix}cc"}
        if [[ $source == opaque ]]; then
          printf '%s\n' -static-pie > linker-policy.rsp
          flags=()
          export NIX_CFLAGS_LINK="@$PWD/linker-policy.rsp"
        elif [[ $source == late ]]; then
          flags=()
          compiler=${lateCompiler}
          export NIX_TEST_LATE_STATIC_PIE=1
        fi
        NIX_LDFLAGS="$rpath" PATH= "$compiler" ${staticLibc} "''${flags[@]}" ${./cc-main.c} -o linker-policy-pie
        "$READELF" -ld linker-policy-pie > linker-policy.headers
        if grep -E 'RPATH|RUNPATH|INTERP' linker-policy.headers; then exit 1; fi
        ${emulator} ./linker-policy-pie
        unset NIX_CFLAGS_LINK NIX_TEST_LATE_STATIC_PIE
      done
    done
    test -e linker-policy-late-hook-ran

    # Equal policy and caller RPATHs must preserve caller search order. Do not
    # execute this deliberately caller-authored static PIE with an RPATH.
    NIX_TEST_LATE_STATIC_PIE=1 \
      NIX_LDFLAGS_BEFORE='-rpath /nix/store/caller-second' NIX_LDFLAGS='-rpath /nix/store/caller-first' \
      PATH= ${lateCompiler} ${staticLibc} ${./cc-main.c} \
      -Wl,-rpath,/nix/store/caller-first -Wl,-rpath,/nix/store/caller-second -o linker-policy-caller-pie
    "$READELF" -d linker-policy-caller-pie > linker-policy.headers
    grep -Fq '[/nix/store/caller-first:/nix/store/caller-second]' linker-policy.headers

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
      NIX_TEST_LATE_STATIC_PIE=1 NIX_LDFLAGS="$symbols" \
        PATH= ${lateCompiler} ${staticLibc} linker-policy-reference.c -o linker-policy-symbols
      "$READELF" -s linker-policy-symbols > linker-policy.symbols
      grep -q 'policy_external' linker-policy.symbols
    done
    if "$LD" --version | grep -q LLD; then
      # Unlike GNU ld, LLD uses even an existing regular -R operand as RPATH.
      NIX_TEST_LATE_STATIC_PIE=1 NIX_LDFLAGS="-R $PWD/linker-policy-symbols.o" \
        PATH= ${lateCompiler} ${staticLibc} ${./cc-main.c} -o linker-policy-existing-rpath
      "$READELF" -ld linker-policy-existing-rpath > linker-policy.headers
      if grep -E 'RPATH|RUNPATH|INTERP' linker-policy.headers; then exit 1; fi
      ${emulator} ./linker-policy-existing-rpath
    fi
  ''}
''
