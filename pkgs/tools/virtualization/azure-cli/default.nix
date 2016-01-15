{ recurseIntoAttrs, callPackage, nodejs
}:

let
  self = (
    callPackage ../../../top-level/node-packages.nix {
      inherit nodejs self;
      generated = callPackage ./node-packages.nix { inherit self; };
      overrides = {
        "azure-cli" = { passthru.nodePackages = self; };
        "easy-table" = {
            dontMakeSourcesWritable = 1;
            postUnpack = ''
                chmod -R 770 "$sourceRoot"
           '';
        };
      };
    });
in self.azure-cli

