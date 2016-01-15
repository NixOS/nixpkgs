{ recurseIntoAttrs, callPackage, nodejs, makeWrapper
}:

let
  self = (
    callPackage ../../../top-level/node-packages.nix {
      inherit nodejs self;
      generated = callPackage ./node-packages.nix { inherit self; };
      overrides = {

        "azure-cli" =
        let
           streamline-streams = self.by-version."streamline-streams"."0.1.5";
           streamline = self.by-version."streamline"."0.10.17";
           node-uuid = self.by-version."node-uuid"."1.2.0";
        in {
            passthru.nodePackages = self;

            buildInputs = [ makeWrapper ];

            postInstall = ''
              wrapProgram "$out/bin/azure" \
                --set NODE_PATH "${streamline-streams}/lib/node_modules:${streamline}/lib/node_modules:${node-uuid}/lib/node_modules"
            '';
        };
        "easy-table" = {
            dontMakeSourcesWritable = 1;
            postUnpack = ''
                chmod -R 770 "$sourceRoot"
           '';
        };
      };
    });
in self.azure-cli

