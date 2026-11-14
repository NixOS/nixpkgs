{
  lib,
  stdenv,
  CC,
}:
lib.optionalString (stdenv.cc.isClang && (stdenv.cc.cc.nativePrimaryQuery or null) == "fd-v3") ''
  (
  # These cases select non-GNU option grammars deliberately. The surrounding
  # stdenv's opaque GNU hardening/dependency flags are not mode translations.
  # Keep constructor defaults, and supply explicit policy in the cases below.
  for nativePolicyVariable in "''${!NIX_CFLAGS_@}" "''${!NIX_CXXSTDLIB_@}" \
      "''${!NIX_HARDENING_ENABLE@}"; do
    unset "$nativePolicyVariable"
  done
  echo "checking native driver modes and forwarded caller policy..." >&2
  cat > native-policy.c <<'EOF'
  int native_policy(void) { return 42; }
  EOF

  # CL mode owns its native argument and response-file grammar. It is a
  # supported mode of the selected raw clang, not another executable.
  ${CC} --driver-mode=cl --version > native-cl-version.log
  grep -F 'clang version' native-cl-version.log
  # Flang/DXC have different toolchain policy requirements. Probe the native
  # frame's option visibility with empty policy, rather than adding this C
  # wrapper's GNU search-path and frame-pointer flags to those personalities.
  queryNativeMode() {
    local -a args=("--driver-mode=$1" --version)
    if [[ $1 == dxc ]]; then args+=(-T ps_6_0); fi
    printf '%s\0' nix-primary-v3 0 0 "" "" 0 "''${#args[@]}" 0 0 0 0 \
      "''${args[@]}" > native-mode.request
    NIX_CC_PRIMARY_ARGS_FD=3 NIX_CC_PRIMARY_QUERY_FD=4 \
      ${stdenv.cc.cc}/bin/clang 3< native-mode.request 4> native-mode.result
    grep -aF 'requested_host_link=0' native-mode.result
  }
  queryNativeMode flang
  queryNativeMode dxc
  ${CC} --driver-mode=cl /c native-policy.c /Fonative-cl.obj
  test -s native-cl.obj
  ${lib.optionalString (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64) ''
    ${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}readelf -h native-cl.obj | grep -F 'ELF'
    ${CC} --driver-mode=cl --target=x86_64-pc-windows-msvc /c native-policy.c \
      /Fonative-cl-windows.obj
    ${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}objdump -f native-cl-windows.obj | grep -E '(pe|coff)-x86-64'
    ${CC} --driver-mode=cl /clang:--target=x86_64-pc-windows-msvc /c native-policy.c \
      /Fonative-cl-forwarded-windows.obj
    ${stdenv.cc.bintools}/bin/${stdenv.cc.targetPrefix}objdump -f native-cl-forwarded-windows.obj | grep -E '(pe|coff)-x86-64'
  ''}
  cp native-policy.c 'native policy.c'
  printf '%s\n' '/c "native policy.c" /Fo"native response.obj"' > native-cl.rsp
  ${CC} --driver-mode=cl @native-cl.rsp
  test -s 'native response.obj'

  # /link consumes only its response-file line. A trailing caller -### must
  # remain a dry run, and options on the next line remain compiler options.
  cat > native-cl-eol.c <<'EOF'
  #ifndef NATIVE_AFTER_LINK_LINE
  #error response-file /link swallowed the following compiler line
  #endif
  int native_eol(void) { return 42; }
  EOF
  printf '%s\n' '/c native-cl-eol.c /Fonative-cl-eol.obj' \
    '/link /DEBUG' '/DNATIVE_AFTER_LINK_LINE=1' > native-cl-eol.rsp
  printf '%s\n' '@native-cl-eol.rsp' > native-cl-eol-nested.rsp
  for response in native-cl-eol.rsp native-cl-eol-nested.rsp; do
    NIX_ENFORCE_PURITY=1 NIX_ENFORCE_NO_NATIVE=1 \
      ${CC} --driver-mode=cl "@$response" -### > native-cl-eol.log 2>&1
    test ! -e native-cl-eol.obj
    grep -F 'NATIVE_AFTER_LINK_LINE=1' native-cl-eol.log
    NIX_ENFORCE_PURITY=1 NIX_ENFORCE_NO_NATIVE=1 \
      ${CC} --driver-mode=cl "@$response"
    test -s native-cl-eol.obj
    rm native-cl-eol.obj
  done

  # Native offload discovery can execute a helper under ordinary -###. The
  # optional suppressed SHOW_JOBS query must return metadata without doing so.
  cat > native-offload-helper <<'EOF'
  #!${stdenv.shell}
  echo ran > "$PWD/native-offload-helper-ran"
  echo sm_80
  EOF
  chmod +x native-offload-helper
  nativeOffloadArgs=(-fopenmp -fopenmp-targets=nvptx64-nvidia-cuda \
    --offload-arch=native "--offload-arch-tool=$PWD/native-offload-helper" \
    -nocudalib -c native-policy.c)
  printf '%s\0' nix-primary-v3 0 0 "" "" 0 "''${#nativeOffloadArgs[@]}" 0 0 0 0 \
    "''${nativeOffloadArgs[@]}" > native-offload.request
  NIX_CC_PRIMARY_ARGS_FD=3 NIX_CC_PRIMARY_QUERY_FD=4 NIX_CC_PRIMARY_SHOW_JOBS=1 \
    ${stdenv.cc.cc}/bin/clang 3< native-offload.request 4> native-offload.result \
    > native-offload.log 2>&1
  test ! -e native-offload-helper-ran
  grep -aF 'requested_host_link=0' native-offload.result
  grep -F 'Target: ' native-offload.log

  impure=/nix-wrapper-impure-native-policy
  observePolicy() {
    NIX_ENFORCE_PURITY=1 NIX_ENFORCE_NO_NATIVE=1 \
      ${CC} -### -c native-policy.c "$@" > native-policy.log 2>&1
  }
  rejectsCallerPath() {
    observePolicy "$@"
    if grep -F -- "$impure" native-policy.log; then
      echo "A caller include escaped purity through native forwarding" >&2
      exit 1
    fi
  }
  rejectsCallerPath -Xarch_host "-I$impure"
  rejectsCallerPath -Xarch_${stdenv.hostPlatform.parsed.cpu.name} "-I$impure"
  rejectsCallerPath -Xclang -I -Xclang "$impure"
  rejectsCallerPath -Xpreprocessor -I -Xpreprocessor "$impure"
  rejectsCallerPath "-Wp,-DRETAIN_FIRST=1,-I,$impure,-DRETAIN_LAST=1"
  grep -F 'RETAIN_FIRST=1' native-policy.log
  grep -F 'RETAIN_LAST=1' native-policy.log
  rejectsCallerPath --driver-mode=cl /c "/clang:-I$impure"
  rejectsCallerPath --driver-mode=cl /c /clang:-Xclang /clang:-I \
    /clang:-Xclang "/clang:$impure"

  # Native CL/_CL_ grammar turns # into = and places caller arguments
  # before/after all trusted wrapper groups. Do not move them inside policy.
  CL="/clang:-I$impure" rejectsCallerPath --driver-mode=cl /c
  _CL_="/clang:-I$impure" rejectsCallerPath --driver-mode=cl /c
  CL="/I$impure" rejectsCallerPath --driver-mode=cl /c
  CL="/D/clang:-I$impure" observePolicy --driver-mode=cl /c
  grep -F -- "$impure" native-policy.log
  CL="/clang:-I$impure/caller" \
    NIX_CFLAGS_COMPILE="/clang:-I$impure/trusted" observePolicy --driver-mode=cl /c
  if grep -F -- "$impure/caller" native-policy.log; then exit 1; fi
  grep -F -- "$impure/trusted" native-policy.log
  cat > native-cl-env.c <<'EOF'
  #if NATIVE_ENV != EXPECTED
  #error CL environment arguments lost their native order
  #endif
  int native_env(void) { return NATIVE_ENV; }
  EOF
  CL='/DNATIVE_ENV#1' NIX_CFLAGS_COMPILE='/DNATIVE_ENV=2' \
    ${CC} --driver-mode=cl /c /DEXPECTED=2 native-cl-env.c /Fonative-cl-env.obj
  CL='/DNATIVE_ENV#1' _CL_='/DNATIVE_ENV#4' NIX_CFLAGS_COMPILE='/DNATIVE_ENV=2' \
    ${CC} --driver-mode=cl /c /DEXPECTED=4 native-cl-env.c /Fonative-cl-env.obj

  # Native response lexing/CL environment decisions precede expansion,
  # while option ownership follows the driver mode selected after expansion.
  printf '%s\n' "--driver-mode=cl /c /D -I$impure native-policy.c" > native-cl-mode.rsp
  CL='/DUNEXPECTED_CL_ENV#1' observePolicy @native-cl-mode.rsp
  grep -F -- "$impure" native-policy.log
  if grep -F UNEXPECTED_CL_ENV native-policy.log; then exit 1; fi
  printf '%s\n' '--driver-mode=g++ -c native-policy.c' > native-gxx-mode.rsp
  CL="-I$impure" rejectsCallerPath --driver-mode=cl @native-gxx-mode.rsp

  _CL_='--driver-mode=g++' NIX_CXXSTDLIB_COMPILE='-DNATIVE_ENV_CXX_POLICY=1' \
    observePolicy --driver-mode=cl
  grep -F NATIVE_ENV_CXX_POLICY native-policy.log

  # Conditional C++ policy is selected once. It may change the final native
  # mode, including whether the final command processes CL environment input.
  _CL_='--driver-mode=gcc' \
    NIX_CXXSTDLIB_COMPILE='--driver-mode=cl -DNATIVE_CXX_SELECTED_ONCE=1' \
    observePolicy --driver-mode=g++
  grep -F NATIVE_CXX_SELECTED_ONCE native-policy.log

  # Preserve option ownership: forwarded -D consumes its next carrier's
  # payload, even when that payload looks like an include option.
  observePolicy -Xclang -D -Xclang "-I$impure"
  grep -F -- "$impure" native-policy.log
  # A scoped option with a missing operand must retain native diagnostics;
  # it cannot consume a following Xarch carrier's payload.
  if observePolicy -Xarch_host -I; then
    echo "An invalid scoped option lost its native diagnostic" >&2
    exit 1
  fi

  # Trusted policy is distinct from caller arguments even after forwarding.
  NIX_CFLAGS_COMPILE="-Xclang -I -Xclang $impure" observePolicy
  grep -F -- "$impure" native-policy.log
  NIX_CFLAGS_COMPILE="-Xarch_host -I$impure" observePolicy
  grep -F -- "$impure" native-policy.log

  observePolicy -Xarch_host -march=native
  grep -F 'Skipping impure flag -march=native' native-policy.log
  )
''
