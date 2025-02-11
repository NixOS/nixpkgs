{
  lib,
  newScope,
  callPackage,
  ghidra,
}:

lib.makeScope newScope (self: {
  inherit (callPackage ./build-extension.nix { inherit ghidra; })
    buildGhidraExtension
    buildGhidraScripts
    ;

  findcrypt = self.callPackage ./extensions/findcrypt { };

  ghidra-delinker-extension = self.callPackage ./extensions/ghidra-delinker-extension {
    inherit ghidra;
  };

  ghidra-golanganalyzerextension = self.callPackage ./extensions/ghidra-golanganalyzerextension { };

  ghidraninja-ghidra-scripts = self.callPackage ./extensions/ghidraninja-ghidra-scripts { };

  gnudisassembler = self.callPackage ./extensions/gnudisassembler { inherit ghidra; };

  lightkeeper = self.callPackage ./extensions/lightkeeper { };

  machinelearning = self.callPackage ./extensions/machinelearning { inherit ghidra; };

  ret-sync = self.callPackage ./extensions/ret-sync { };

  sleighdevtools = self.callPackage ./extensions/sleighdevtools { inherit ghidra; };

  wasm = self.callPackage ./extensions/wasm { inherit ghidra; };
})
