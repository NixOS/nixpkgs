self: {
  buildBatExtrasPkg = self.callPackage ./buildBatExtrasPkg.nix { };

  core = self.callPackage ./modules/core.nix { };
  batdiff = self.callPackage ./modules/batdiff.nix { };
  batgrep = self.callPackage ./modules/batgrep.nix { };
  batman = self.callPackage ./modules/batman.nix { };
  batpipe = self.callPackage ./modules/batpipe.nix { };
  batwatch = self.callPackage ./modules/batwatch.nix { };
  prettybat = self.callPackage ./modules/prettybat.nix { };
}
