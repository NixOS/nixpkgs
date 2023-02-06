{ lib }:

{
  name = "ghidra-patch-use-vmargs-env";
  postPatch = ''
    replaceSymlinkWithFile() {
      if [ -L "$1" ]; then
        cp --remove-destination "$(readlink "$1")" "$1"
      fi
    }

    d=lib/ghidra
    cd $out/$d
    f=ghidraRun
    replaceSymlinkWithFile $f
    substituteInPlace $f \
      --replace \
        'Ghidra "''${MAXMEM}" "" ghidra.GhidraRun' \
        'Ghidra "''${MAXMEM}" "$VMARGS" ghidra.GhidraRun'
  '';
}
