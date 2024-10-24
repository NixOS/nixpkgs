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

  ghidraninja-ghidra-scripts = self.callPackage ./extensions/ghidraninja-ghidra-scripts { };

  ghidra-delinker-extension = self.callPackage ./extensions/ghidra-delinker-extension {
    inherit ghidra;
  };

  ghidra-golanganalyzerextension = self.callPackage ./extensions/ghidra-golanganalyzerextension { };

  gnudisassembler = self.callPackage ./extensions/gnudisassembler { inherit ghidra; };

  lightkeeper = self.callPackage ./extensions/lightkeeper { };

  machinelearning = self.callPackage ./extensions/machinelearning { inherit ghidra; };

  ret-sync = self.callPackage ./extensions/ret-sync { };

  sleighdevtools = self.callPackage ./extensions/sleighdevtools { inherit ghidra; };

})
