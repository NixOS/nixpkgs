{ lib, runCommandCC, libxkbcommon }:

runCommandCC "xkbvalidate" {
  buildInputs = [ libxkbcommon ];
  meta = {
    description = "NixOS tool to validate X keyboard configuration";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.aszlig ];
  };
} ''
  mkdir -p "$out/bin"
  gcc -std=gnu11 -Wall -pedantic -lxkbcommon ${./xkbvalidate.c} \
    -o "$out/bin/validate"
''
