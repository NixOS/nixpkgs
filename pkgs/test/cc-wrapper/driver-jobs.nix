{
  lib,
  stdenv,
  CC,
  staticLibc,
  emulator ? "",
  lld ? null,
}:
let
  inherit (stdenv.cc) suffixSalt targetPrefix;
  rawLD = lib.getExe' stdenv.cc.bintools.bintools "${targetPrefix}ld";
  readelf = lib.getExe' stdenv.cc.bintools.bintools "${targetPrefix}readelf";
  rawCC = lib.getExe' stdenv.cc.cc "${targetPrefix}${if stdenv.cc.isClang then "clang" else "gcc"}";
  linkerIsLLVM = stdenv.cc.bintools.bintools.isLLVM or false;
in
lib.optionalString
  (
    stdenv.hostPlatform.isLinux
    && (
      (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "8")
      || (stdenv.cc.isClang && lib.versionAtLeast stdenv.cc.version "12")
    )
  )
  ''
    echo 'checking compiler-owned hidden link modes with an unwrapped linker' >&2
    ${lib.optionalString (stdenv.cc.isGNU && !linkerIsLLVM) ''
      # An output filename is not a linker selector. Misreading this operand
      # as LLD selection discards GNU -R's existing symbol-file input.
      printf 'int selector_operand_symbol;\n' > selector-symbols.c
      printf 'int selector_entry(void) { return 0; }\n' > selector-entry.c
      ${CC} -c selector-symbols.c -o selector-symbols.o
      for output in selector-control -fuse-ld=lld \
          $'line\n "ld.lld" "-static" "-pie" "--no-dynamic-linker"\n tail'; do
        NIX_LDFLAGS="-R $PWD/selector-symbols.o" \
          ${CC} -nostdlib -static-pie -Wl,-e,selector_entry selector-entry.c -o "$output"
        ${readelf} -sW "./$output" | grep -q ' selector_operand_symbol$'
      done
      # collect2 consumes this private option but does not recognize an
      # absolute path as a linker selector, so GNU symbol import must remain.
      NIX_LDFLAGS="-R $PWD/selector-symbols.o" \
        ${CC} -nostdlib -static-pie -Wl,-e,selector_entry \
        -Wl,--soname,-fuse-ld=/unused/ld.lld,collect2-gnu \
        selector-entry.c -o collect2-path-operand
      ${readelf} -sW collect2-path-operand | grep -q ' selector_operand_symbol$'
      ${lib.optionalString (lld != null && lib.versionAtLeast stdenv.cc.version "9") ''
        # collect2, unlike ld, consumes a selector inside a SONAME operand.
        # The following mode-shaped value then becomes the actual SONAME.
        mkdir collect2-linker
        ln -s ${lld}/bin/ld.lld collect2-linker/ld.lld
        for soname in collect2-soname -no-pie; do
          NIX_LDFLAGS="-R $PWD/selector-symbols.o" \
            ${CC} -B"$PWD/collect2-linker/" -nostdlib -static-pie \
            -Wl,-e,selector_entry "-Wl,--soname,-fuse-ld=lld,$soname" \
            selector-entry.c -o collect2-selector
          ${readelf} -hld collect2-selector > collect2-selector.headers
          grep -F "[$soname]" collect2-selector.headers
          grep -q 'FLAGS_1.*PIE' collect2-selector.headers
          if grep -E 'RPATH|RUNPATH|INTERP' collect2-selector.headers; then exit 1; fi
        done
      ''}
    ''}
    ${lib.optionalString (stdenv.cc.isClang && !linkerIsLLVM && lld != null) ''
      # A config can select LLD after MAIN policy was provisionally rendered
      # with GNU operand rules. Observation must be repeated if that rendering
      # changes, or it can retain an RPATH in the final static PIE.
      printf 'void flavor_entry(void) {}\n' > linker-flavor.c
      ${CC} -fPIC -c linker-flavor.c -o linker-flavor.o
      printf '%s\n' '--ld-path=${lld}/bin/ld.lld' > linker-flavor.cfg
      for selection in visible config; do
        if [[ $selection == visible ]]; then
          linkerSelection=(--ld-path=${lld}/bin/ld.lld)
        else
          linkerSelection=(--config="$PWD/linker-flavor.cfg")
        fi
        NIX_LDFLAGS="-library-path -L/operand-path -pie --no-dynamic-linker -R $PWD/linker-flavor.o" \
          ${CC} "''${linkerSelection[@]}" -no-pie -nostdlib -Wl,-e,flavor_entry \
          linker-flavor.o -o linker-flavor
        ${readelf} -hld linker-flavor > linker-flavor.headers
        grep -q 'FLAGS_1.*PIE' linker-flavor.headers
        if grep -E 'RPATH|RUNPATH|INTERP' linker-flavor.headers; then exit 1; fi
      done
    ''}
    mkdir -p raw-linker
    ln -s ${rawLD} raw-linker/ld
    ln -s ${rawLD} raw-linker/ld.${if linkerIsLLVM then "lld" else "bfd"}
    ${lib.optionalString (targetPrefix != "") "ln -s ${rawLD} raw-linker/${targetPrefix}ld"}
    forwardedRpaths='-Wl,--rpath=/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hidden-mode/wl -Wl,-rpath,/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hidden-mode/joined -Xlinker -rpath -Xlinker /nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hidden-mode/xlinker'
    forwardedRpaths+=' -Wl,-R,/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hidden-mode/alias'
    ${lib.optionalString (!linkerIsLLVM)
      "forwardedRpaths+=' -Xlinker --just-symbols=/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hidden-mode/long-alias' "
    }
    for hiddenMode in static static-pie shared; do
      modeLibc=()
      if [[ $hiddenMode != shared ]]; then modeLibc=(${staticLibc}); fi
      ${
        if stdenv.cc.isClang then
          ''
            printf '%s\n' "-$hiddenMode" '--ld-path=${rawLD}' > hidden-link.cfg
            hiddenArgs=(--config="$PWD/hidden-link.cfg")
          ''
        else
          ''
            printf '*self_spec:\n+ -%s\n' "$hiddenMode" > hidden-link.specs
            hiddenArgs=(-specs="$PWD/hidden-link.specs" -B"$PWD/raw-linker/" -fuse-ld=${
              if linkerIsLLVM then "lld" else "bfd"
            })
          ''
      }
      env NIX_LDFLAGS_${suffixSalt}='-rpath /nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hidden-mode/lib' \
        NIX_CFLAGS_LINK_${suffixSalt}="$forwardedRpaths" \
        ${CC} "''${hiddenArgs[@]}" -### ${./cc-main.c} "''${modeLibc[@]}" \
        -o "hidden-$hiddenMode" 2> "hidden-$hiddenMode.log"
      # The wrapper must not inject an interpreter into static or shared
      # links, even when only the driver can see the effective mode.
      if grep -E -- '(^|[ "])--?dynamic-linker[= "]' "hidden-$hiddenMode.log"; then
        echo "unexpected interpreter policy for hidden $hiddenMode" >&2
        exit 1
      fi
      if [[ $hiddenMode == static-pie ]]; then
        if grep -F 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hidden-mode' "hidden-$hiddenMode.log"; then
          echo 'unexpected RPATH policy for hidden static PIE' >&2
          exit 1
        fi
      fi
      env NIX_LDFLAGS_${suffixSalt}='--rpath=/nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-hidden-mode/lib' \
        NIX_CFLAGS_LINK_${suffixSalt}="$forwardedRpaths" \
        ${CC} "''${hiddenArgs[@]}" -fPIC ${./cc-main.c} "''${modeLibc[@]}" -o "hidden-$hiddenMode"
      ${readelf} -l "hidden-$hiddenMode" > "hidden-$hiddenMode.headers"
      if grep -F INTERP "hidden-$hiddenMode.headers"; then exit 1; fi
      if [[ $hiddenMode == shared ]]; then
        ${readelf} -h "hidden-$hiddenMode" | grep -F DYN
      else
        ${emulator} ./hidden-"$hiddenMode"
      fi
      if [[ $hiddenMode == static-pie ]]; then
        ${readelf} -d "hidden-$hiddenMode" > hidden-static-pie.dynamic
        if grep -E 'RPATH|RUNPATH' hidden-static-pie.dynamic; then exit 1; fi
      fi
    done

    # BEFORE linker policy must precede caller overrides in the observation,
    # just as it does in execution. A stale static-PIE result would drop RPATH.
    env NIX_LDFLAGS_BEFORE_${suffixSalt}='-static -pie --no-dynamic-linker' \
      NIX_LDFLAGS_${suffixSalt}='-rpath /nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-before-order/lib' \
      ${CC} ${
        if stdenv.cc.isClang then
          "--ld-path=${rawLD}"
        else
          ''-B"$PWD/raw-linker/" -fuse-ld=${if linkerIsLLVM then "lld" else "bfd"}''
      } -no-pie -Wl,-Bdynamic,-no-pie,--dynamic-linker=${stdenv.cc.bintools.dynamicLinker} \
      ${./cc-main.c} -o before-overridden
    ${emulator} ./before-overridden
    ${readelf} -l before-overridden | grep -F INTERP
    ${readelf} -d before-overridden | grep -F /nix/store/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa-before-order/lib

    # Output names are operands even when they look like an RPATH option.
    env NIX_CFLAGS_LINK_${suffixSalt}='-o --rpath' \
      ${CC} -static-pie ${./cc-main.c} ${staticLibc} -o output-overridden
    ${emulator} ./--rpath
    env NIX_CFLAGS_LINK_${suffixSalt}='--output --rpath' \
      ${CC} -static-pie ${./cc-main.c} ${staticLibc} -o output-overridden
    ${emulator} ./--rpath
    env NIX_CFLAGS_LINK_${suffixSalt}='-Xlinker --output -Xlinker -rpath' \
      ${CC} -static-pie ${./cc-main.c} ${staticLibc} -o output-overridden
    ${emulator} ./-rpath

    # Displayed argv is data, including whitespace, quoting and shell syntax.
    source ${stdenv.cc}/nix-support/utils.bash
    source ${stdenv.cc}/nix-support/generic-query.sh
    wrapperReadJob ' "/compiler path/ld" "a b" "$(touch job-parser-executed)"'
    [[ ''${wrapperJob[0]} == '/compiler path/ld' && ''${wrapperJob[1]} == 'a b' ]]
    [[ ''${wrapperJob[2]} == '$(touch job-parser-executed)' && ! -e job-parser-executed ]]
    if wrapperReadJob ' "unterminated'; then exit 1; fi
    [[ $(filterCompilerRpathFlags static-pie -Wl,-Map,-rpath -Wl,--rpath=/removed -pthread) == '-Wl,-Map -Wl,-rpath -pthread' ]]
    [[ $(filterCompilerRpathFlags static-pie -o --rpath) == '-o --rpath' ]]
    [[ $(filterCompilerRpathFlags static-pie --output --rpath) == '--output --rpath' ]]
    [[ $(filterCompilerRpathFlags static-pie -Xlinker --output -Xlinker -rpath) == '-Xlinker --output -Xlinker -rpath' ]]
    [[ $(filterCompilerRpathFlags static-pie -- --rpath) == '-- --rpath' ]]
    [[ $(filterCompilerRpathFlags static-pie -Wl,--,-rpath) == '-Wl,-- -Wl,-rpath' ]]
    [[ $(filterCompilerRpathFlags static-pie -Wl,-rpath, -Wl,--export-dynamic) == '-Wl,--export-dynamic' ]]
    [[ $(filterCompilerRpathFlags static-pie -Wl,-Map, -Wl,--rpath=/removed) == '-Wl,-Map -Wl,' ]]
    # Compiler-only operands do not consume pending linker operands. Libraries
    # do: joined and separate driver spellings lower to the same linker token.
    for option in -u -T -D -U --config -resource-dir -working-directory -F -iframework; do
      [[ $(filterCompilerRpathFlags static-pie -Wl,-Map "$option" value -Wl,--rpath=/map-name) == "-Wl,-Map $option value -Wl,--rpath=/map-name" ]]
    done
    [[ $(filterCompilerRpathFlags static-pie -Wl,-Map -lm -Wl,--rpath=/removed) == '-Wl,-Map -lm' ]]
    [[ $(filterCompilerRpathFlags static-pie -Wl,-Map -l m -Wl,--rpath=/removed) == '-Wl,-Map -lm' ]]
    for libraryFlags in '-lm' '-l m'; do
      env NIX_CFLAGS_LINK_${suffixSalt}="-Wl,-Map $libraryFlags -Wl,--rpath=/nix/store/library-map-policy" \
        ${CC} -static-pie ${./cc-main.c} ${staticLibc} -o library-map-static-pie
      ${readelf} -ld library-map-static-pie > library-map-static-pie.headers
      if grep -E 'RPATH|RUNPATH|INTERP' library-map-static-pie.headers; then exit 1; fi
      ${emulator} ./library-map-static-pie
    done
    env NIX_CFLAGS_LINK_${suffixSalt}="-Wl,-rpath, -Wl,-Map,$PWD/empty-rpath.map" \
      ${CC} -static-pie ${./cc-main.c} ${staticLibc} -o empty-rpath-static-pie
    test -s empty-rpath.map
    ${readelf} -ld empty-rpath-static-pie > empty-rpath-static-pie.headers
    if grep -E 'RPATH|RUNPATH|INTERP' empty-rpath-static-pie.headers; then exit 1; fi
    ${emulator} ./empty-rpath-static-pie
    # A raw input filename can be the Map operand in lowered linker argv.
    # It must not leave Map pending until the following RPATH option.
    touch policy-map.o
    env NIX_CFLAGS_LINK_${suffixSalt}="-Wl,-Map $PWD/policy-map.o -Wl,--rpath=/nix/store/map-policy" \
      ${CC} -static-pie ${./cc-main.c} ${staticLibc} -o map-operand-static-pie
    ${readelf} -ld map-operand-static-pie > map-operand-static-pie.headers
    if grep -E 'RPATH|RUNPATH|INTERP' map-operand-static-pie.headers; then exit 1; fi
    ${emulator} ./map-operand-static-pie
    [[ $(filterRpathFlags static-pie -- -rpath) == '-- -rpath' ]]
    wrapperLinkerIsLLVM=0
    [[ $(filterCompilerRpathFlags static-pie -Wl,-R,/missing-rpath -Xlinker --just-symbols -Xlinker /missing-rpath -pthread) == -pthread ]]
    touch existing-symbol-file
    [[ $(filterCompilerRpathFlags static-pie -Wl,-R,existing-symbol-file) == '-Wl,-R -Wl,existing-symbol-file' ]]
    wrapperLinkerIsLLVM=1
    [[ $(filterCompilerRpathFlags static-pie -Wl,-R,existing-symbol-file -Wl,--just-symbols,existing-symbol-file) == '-Wl,--just-symbols -Wl,existing-symbol-file' ]]
    wrapperLinkerIsLLVM=unknown
    [[ $(filterCompilerRpathFlags static-pie -Wl,-R,/missing-rpath -Wl,--rpath=/removed) == '-Wl,-R -Wl,/missing-rpath' ]]
    unset wrapperLinkerIsLLVM

    # Observation must leave caller-owned immediate outputs for execution.
    # Exercise the compatibility driver directly as well as the native entry.
    ${lib.optionalString stdenv.cc.isClang ''
      # The effective driver target, including an explicit override, decides
      # which architecture-scoped arguments join the host linker stream.
      hostTriple=$(${rawCC} -dumpmachine)
      hostArch=''${hostTriple%%-*}
      wrapperHostArch=$hostArch
      [[ $(filterCompilerRpathFlags static-pie -Xarch_host -Wl,-rpath -Xarch_host -Wl,/removed,--export-dynamic) == '-Xarch_host -Wl,--export-dynamic' ]]
      [[ $(filterCompilerRpathFlags static-pie -Wl,-Map -Xarch_host -Wl,-rpath,/removed -Wl,/map) == '-Wl,-Map -Wl,/map' ]]
      [[ $(filterCompilerRpathFlags static-pie -Xarch_host -Wl,-Map -Wl,--rpath=/removed -Xarch_$hostArch -Wl,/map) == "-Xarch_host -Wl,-Map -Xarch_$hostArch -Wl,/map" ]]
      [[ $(filterCompilerRpathFlags static-pie -Xarch_ignored -Wl,-rpath -Wl,--export-dynamic) == '-Xarch_ignored -Wl,-rpath -Wl,--export-dynamic' ]]
      [[ $(filterCompilerRpathFlags static-pie -Xarch_host -Wl,-Map -Xarch_host -lm -Wl,--rpath=/removed) == '-Xarch_host -Wl,-Map -Xarch_host -lm' ]]
      [[ $(filterCompilerRpathFlags static-pie -Wl,-rpath -z relro -Wl,/retained) == '-Wl,relro -Wl,/retained' ]]
      [[ $(filterCompilerRpathFlags static-pie -Wl,-rpath -framework Matrix -Wl,/retained) == '-Wl,Matrix -Wl,/retained' ]]
      [[ $(filterCompilerRpathFlags static-pie -Xarch_device -Wl,--rpath=/device) == '-Xarch_device -Wl,--rpath=/device' ]]
      [[ $(filterCompilerRpathFlags static-pie -Xarch_host -Wl,-- -Wl,-rpath,/input-file) == '-Xarch_host -Wl,-- -Wl,-rpath -Wl,/input-file' ]]
      [[ $(filterCompilerRpathFlags static-pie -Wl,-- -Xarch_host -Wl,--rpath=/removed) == '-Wl,--' ]]
      for scope in host "$hostArch"; do
        for scopedFlags in \
          "-Xarch_$scope -Wl,--rpath=/nix/store/scoped-policy,--no-undefined" \
          "-Xarch_$scope -Wl,-rpath -Xarch_$scope -Wl,/nix/store/scoped-policy,--no-undefined" \
          "-Xarch_$scope -Wl,-rpath -Xarch_$hostArch -Wl,/nix/store/scoped-policy,--no-undefined" \
          "-Wl,-Map -Xarch_$scope -Wl,-rpath,/nix/store/scoped-policy -Wl,$PWD/scoped.map" \
          "-Xarch_$scope -Wl,-Map -Wl,--rpath=/nix/store/scoped-policy -Xarch_$hostArch -Wl,$PWD/scoped.map"; do
          env NIX_CFLAGS_LINK_${suffixSalt}="$scopedFlags -Xarch_ignored -Wl,-rpath -Wl,--no-undefined" \
            ${CC} -static-pie ${./cc-main.c} ${staticLibc} -o scoped-static-pie
          ${readelf} -ld scoped-static-pie > scoped-static-pie.headers
          if grep -E 'RPATH|RUNPATH|INTERP' scoped-static-pie.headers; then exit 1; fi
          ${emulator} ./scoped-static-pie
        done
      done

      source ${stdenv.cc}/nix-support/primary-query.sh
      wrapperCompiler=${rawCC}
      path_backup=$PATH
      extraBefore=() extraAfter=() positionalArgs=()
      wrapperCFlagsLink= wrapper_NIX_LDFLAGS_BEFORE= wrapper_NIX_LDFLAGS=
      primaryPurity=0 primarySDK= primaryTarget=
      primaryPrefixes=() primaryMachine=()
      wrapper_NIX_ENFORCE_NO_NATIVE=0
      foreignArch=aarch64
      if [[ $hostArch == aarch64 ]]; then foreignArch=x86_64; fi
      params=(--target="$foreignArch-unknown-linux-gnu" -static-pie ${./cc-main.c})
      for nativePrimaryQuery in 0 ${
        lib.optionalString ((stdenv.cc.cc.nativePrimaryQuery or null) == "fd-v3") "1"
      }; do
        linkType=dynamic
        wrapperObserveLinkType
        [[ $linkType == static-pie && $wrapperHostArch == "$foreignArch" ]]
        [[ $(filterCompilerRpathFlags static-pie -Xarch_$foreignArch -Wl,--rpath=/removed -Xarch_$hostArch -Wl,-rpath -Wl,--export-dynamic) == "-Xarch_$hostArch -Wl,-rpath -Wl,--export-dynamic" ]]
      done
      printf '%s\n' '-static-pie' '-MJ' "$PWD/observed.json" \
        '-serialize-diagnostics' "$PWD/observed.dia" > observed.cfg
      params=(--config="$PWD/observed.cfg" ${./cc-main.c})
      for nativePrimaryQuery in 0 ${
        lib.optionalString ((stdenv.cc.cc.nativePrimaryQuery or null) == "fd-v3") "1"
      }; do
        echo sentinel > observed.json
        echo sentinel > observed.dia
        linkType=dynamic
        wrapperObserveLinkType
        [[ $linkType == static-pie ]]
        [[ $(< observed.json) == sentinel && $(< observed.dia) == sentinel ]]
      done
      printf '%s\n' '-static-pie' > observed-link-only.cfg
      touch observed-link-only.o
      params=(--config="$PWD/observed-link-only.cfg" -Werror=unused-command-line-argument "$PWD/observed-link-only.o")
      nativePrimaryQuery=0 linkType=dynamic
      wrapperObserveLinkType
      [[ $linkType == static-pie ]]

      # CCC_OVERRIDE_OPTIONS can remove -### and turn a compatibility
      # observation into execution. An existing output must stay untouched.
      echo sentinel > observed-clang-output.o
      params=(-c ${./cc-main.c} -o "$PWD/observed-clang-output.o")
      nativePrimaryQuery=0 linkType=dynamic
      CCC_OVERRIDE_OPTIONS=x-### wrapperObserveLinkType
      [[ $linkType == dynamic && $(< observed-clang-output.o) == sentinel ]]
    ''}
    ${lib.optionalString stdenv.cc.isGNU ''
      # GNU specs place direct entry/ELF-policy options before linker inputs.
      # Their operands cannot satisfy the later Map option: its option-shaped
      # filename must survive the static-PIE policy filter.
      [[ $(filterCompilerRpathFlags static-pie -Wl,-Map -e entry -Wl,--rpath=/map-name) == '-Wl,-Map -e entry -Wl,--rpath=/map-name' ]]
      [[ $(filterCompilerRpathFlags static-pie -Wl,-Map -z relro -Wl,--rpath=/map-name) == '-Wl,-Map -z relro -Wl,--rpath=/map-name' ]]
      # Exercise the actual compatibility path even with a patched producer.
      # Ordinary specs-selected modes remain observable without native APIs.
      wrapperCompiler=${rawCC}
      path_backup=$PATH
      extraBefore=() extraAfter=() positionalArgs=()
      wrapperCFlagsLink= wrapper_NIX_LDFLAGS_BEFORE= wrapper_NIX_LDFLAGS=
      nativePrimaryQuery=0
      for hiddenMode in static static-pie; do
        printf '*self_spec:\n+ -%s\n' "$hiddenMode" > observed-legacy.specs
        params=(-specs="$PWD/observed-legacy.specs" ${./cc-main.c} -o observed-legacy-output)
        echo sentinel > observed-legacy-output
        linkType=dynamic
        wrapperObserveLinkType
        [[ $linkType == "$hiddenMode" && $(< observed-legacy-output) == sentinel ]]
      done
    ''}
    ${lib.optionalString
      (
        stdenv.cc.isGNU
        && lib.versionAtLeast stdenv.cc.version "15"
        && (stdenv.cc.cc.nativePrimaryQuery or null) == "fd-v3"
      )
      ''
        source ${stdenv.cc}/nix-support/primary-query.sh
        wrapperCompiler=${rawCC}
        path_backup=$PATH
        extraBefore=() extraAfter=() positionalArgs=()
        wrapperCFlagsLink= wrapper_NIX_LDFLAGS_BEFORE= wrapper_NIX_LDFLAGS=
        primaryPurity=0 primarySDK= primaryTarget=
        primaryPrefixes=() primaryMachine=()
        wrapper_NIX_ENFORCE_NO_NATIVE=0 nativePrimaryQuery=1
        echo sentinel > observed-truncate
        echo sentinel > observed-gcc.log
        params=(-static-pie -truncate "$PWD/observed-truncate" ${./cc-main.c})
        linkType=dynamic
        GCC_DIAGNOSTICS_LOG="$PWD/observed-gcc.log" wrapperObserveLinkType
        [[ $linkType == static-pie ]]
        [[ $(< observed-truncate) == sentinel && $(< observed-gcc.log) == sentinel ]]
      ''
    }
  ''
