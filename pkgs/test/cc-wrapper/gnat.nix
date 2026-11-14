{
  gnat,
  runCommand,
  runtimeShell,
  stdenv,
  buildPackages,
}:
let
  compiler = gnat.__spliced.buildHost or gnat;
  prefix = "${compiler}/bin/${compiler.targetPrefix}";
  emulator = stdenv.hostPlatform.emulator buildPackages;
in
runCommand "gnat-wrapper-integration"
  {
    meta.platforms = compiler.meta.platforms;
  }
  ''
    cat > answer.c <<'EOF'
    int c_answer(void) { return 42; }
    EOF
    cat > mixed.adb <<'EOF'
    with Interfaces.C; use Interfaces.C;
    procedure Mixed is
       function C_Answer return int;
       pragma Import (C, C_Answer, "c_answer");
    begin
       if C_Answer /= 42 then
          raise Program_Error;
       end if;
    end Mixed;
    EOF

    # This executes make -> bind -> link -> compiler, including a real C object.
    ${prefix}gcc -c answer.c -o answer.o
    ${prefix}gnatmake -f mixed.adb -o mixed -largs answer.o
    ${emulator} ./mixed

    # The caller's explicit compiler must override the packaged default. The
    # shim records selection and still executes the complete public compiler.
    cat > caller-gcc <<'EOF'
    #!${runtimeShell}
    echo selected >> "$WRAPPER_TEST_LOG"
    exec ${prefix}gcc "$@"
    EOF
    chmod +x caller-gcc
    WRAPPER_TEST_LOG="$PWD/caller.log" \
      ${prefix}gnatmake --GCC="$PWD/caller-gcc" -f mixed.adb \
        -o mixed-caller -largs answer.o
    test -s caller.log
    ${emulator} ./mixed-caller
    touch "$out"
  ''
