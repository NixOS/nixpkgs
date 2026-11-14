{
  lib,
  stdenv,
}:
let
  rawCC = lib.getExe' stdenv.cc.cc (
    if stdenv.cc.isClang then "clang" else "${stdenv.cc.targetPrefix}gcc"
  );
in
lib.optionalString
  (
    stdenv.hostPlatform.isLinux
    && (stdenv.cc.cc.nativePrimaryQuery or null) == "fd-v3-link-policy"
    && (stdenv.cc.isGNU || stdenv.cc.isClang)
  )
  ''
    (
      echo 'checking native primary queries preserve caller output files...' >&2
      source ${stdenv.cc}/nix-support/primary-query.sh
      wrapperCompiler=${rawCC}
      path_backup=$PATH
      wrapper_NIX_CFLAGS_COMPILE_BEFORE= wrapper_CC_CRT_FLAGS=
      wrapper_NIX_CFLAGS_COMPILE= wrapper_NIX_CXXSTDLIB_COMPILE=
      wrapper_NIX_ENFORCE_NO_NATIVE=0
      primaryPurity=0 primarySDK= primaryTarget=
      primaryPrefixes=() primaryMachine=()

      ${lib.optionalString stdenv.cc.isClang ''
        queryArguments=(-static-pie -MJ "$PWD/native-query.json"
          -serialize-diagnostics "$PWD/native-query.dia")
        printf '%s\n' "''${queryArguments[@]}" > native-query-effects.cfg
        for source in arguments configuration; do
          echo sentinel > native-query.json
          echo sentinel > native-query.dia
          if [[ $source == configuration ]]; then
            params=(--config="$PWD/native-query-effects.cfg" ${./cc-main.c})
          else
            params=("''${queryArguments[@]}" ${./cc-main.c})
          fi
          wrapperQueryPrimary
          [[ $dontLink == 0 && $primaryLinkPolicy == static-pie ]]
          [[ $(< native-query.json) == sentinel && $(< native-query.dia) == sentinel ]]
        done

        # Immediate queries skip action bodies, including runtime selection;
        # verbose requests retain native missing-input suppression quietly.
        primaryBefore=() primaryAfter=() primaryCPP=()
        for action in --version --help --print-resource-dir --print-libgcc-file-name -v; do
          echo sentinel > native-query.json
          params=("$action" -MJ "$PWD/native-query.json")
          if [[ $action == --print-libgcc-file-name ]]; then params+=(--rtlib=invalid); fi
          wrapperWriteNativeFrame > native-immediate.request
          NIX_CC_PRIMARY_ARGS_FD=3 NIX_CC_PRIMARY_QUERY_FD=4 \
            ${rawCC} 3< native-immediate.request 4> native-immediate.result \
            > native-immediate.stdout 2> native-immediate.stderr
          [[ ! -s native-immediate.stdout && ! -s native-immediate.stderr ]]
          [[ $(< native-query.json) == sentinel ]]
          grep -aF 'requested_host_link=0' native-immediate.result
        done
      ''}

      ${lib.optionalString stdenv.cc.isGNU ''
        (
          mkdir native-query-effects
          cd native-query-effects
          mkdir caller
          printf 'int value;\n' > input.c
          printf '%s\n' '-DQUERY_PAYLOAD=1' > caller.rsp
          # %@ emits a response only when a caller response was expanded.
          printf '*cc1:\n+ %%@{D*}\n\n' > response.specs
          printf '%s\n' 'echo executed >> caller/executed' 'exec "$@"' > observe.sh
          params=(-fsyntax-only input.c @caller.rsp -specs=response.specs
            -save-temps=obj -dumpdir caller/ -dumpbase probe
            -time=caller/timing -wrapper "${stdenv.shell},$PWD/observe.sh")
          wrapperQueryPrimary
          [[ $dontLink == 1 && -z $(find caller -type f -print) ]]
          [[ -z $(find . -maxdepth 1 -name 'probe.args.*' -print) ]]
          # Confirm these inputs really request subprocess and file effects.
          ${rawCC} "''${params[@]}"
          [[ -s caller/executed && -s caller/timing ]]
          grep -F QUERY_PAYLOAD=1 probe.args.*

          for outcome in success error; do
            echo sentinel > caller/delete-me
            printf '*cc1:\n+ %%dcaller/delete-me' > delete.specs
            if [[ $outcome == error ]]; then printf ' %%eintentional spec error' >> delete.specs; fi
            printf '\n\n' >> delete.specs
            params=(-fsyntax-only input.c -specs=delete.specs)
            status=0
            wrapperQueryPrimary || status=$?
            [[ $(< caller/delete-me) == sentinel ]]
            if [[ $outcome == success ]]; then [[ $status == 0 ]]; else [[ $status == 1 ]]; fi
          done
        )
      ''}

      ${lib.optionalString (stdenv.cc.isGNU && lib.versionAtLeast stdenv.cc.version "15") ''
        echo sentinel > native-query-truncate
        echo sentinel > native-query-gcc.log
        params=(-static-pie -truncate "$PWD/native-query-truncate" ${./cc-main.c})
        GCC_DIAGNOSTICS_LOG="$PWD/native-query-gcc.log" wrapperQueryPrimary
        [[ $dontLink == 0 && $primaryLinkPolicy == static-pie ]]
        [[ $(< native-query-truncate) == sentinel && $(< native-query-gcc.log) == sentinel ]]
      ''}
    )
  ''
