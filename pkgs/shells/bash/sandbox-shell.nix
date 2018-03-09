{ stdenv, lib, bash, glibc, musl }:

let
  # musl roadmap has RISC-V support projected for 1.1.20
  useMusl = !stdenv.hostPlatform.isRiscV;

in

# Minimal shell for use as basic /bin/sh in sandbox builds
bash.overrideAttrs (attrs: {
  outputs = [ "out" ];

  # Musl baseline size is 957K
  configureFlags = (attrs.configureFlags or []) ++ [
    "--disable-help-builtin"            # -56 K
    "--disable-multibyte"               # -206 K
    "--with-bash-malloc=no"             # -20 K
    "--disable-debugger"                # -4 K
    "--disable-function-import"         # -0 K? probably gets implicitly disabled with -static
    "--disable-bang-history"            # -4 K
    "--disable-prompt-string-decoding"  # -0 K? probably already implicitly disabled without readline
  ];

  # Make a static build. It does have an --enable-static-link flag but it doesn't work.
  buildInputs = (attrs.buildInputs or []) ++ lib.optional (!useMusl) glibc.static;
  postConfigure = (attrs.postConfigure or "") + (if useMusl then ''
    makeFlagsArray+=("CC=${stdenv.cc.targetPrefix}cc -Os -static -isystem ${musl.dev}/include -B${musl}/lib -L${musl}/lib")
  '' else ''
    makeFlagsArray+=("CC=${stdenv.cc.targetPrefix}cc -Os -static")
  '');

  # Strip further, seems to be needed for some reason.
  postFixup = (attrs.postFixup or "") + ''
    strip $out/bin/bash
  '';
})
