{ runtimeShell
, symlinkJoin
, writeTextFile
}:

{ emulator, rom }:

assert emulator.version == rom.version;

let
  runScript = writeTextFile {
    name = "run-x16";
    text = ''
      #!${runtimeShell}

      defaultRom="${rom}/share/x16-rom/rom.bin"

      exec "${emulator}/bin/x16emu" -rom $defaultRom "$@"
    '';
    executable = true;
    destination = "/bin/run-x16";
  };
in
symlinkJoin {
  name = "run-x16-${emulator.version}";

  paths = [
    emulator
    rom
    runScript
  ];
}
# TODO [ AndersonTorres ]:

# 1. Parse the command line in order to allow the user to set an optional
# rom-file
# 2. generate runScript based on symlinkJoin (maybe a postBuild?)
