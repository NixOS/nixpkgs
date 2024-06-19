{ lib, runCommandCC, libxkbcommon }:

runCommandCC "xkbvalidate" {
  buildInputs = [ libxkbcommon ];
  meta = {
    description = "NixOS tool to validate X keyboard configuration";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.aszlig ];
    mainProgram = "xkbvalidate";
  };
} ''
  mkdir -p "$out/bin"
  $CC -std=c11 -Wall -pedantic -lxkbcommon ${./xkbvalidate.c} \
    -o "$out/bin/xkbvalidate"
''
