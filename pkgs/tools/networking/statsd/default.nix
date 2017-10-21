{ recurseIntoAttrs, callPackage, nodejs
}:

let
  self = recurseIntoAttrs (
    callPackage ../../../top-level/node-packages.nix {
      inherit nodejs self;
      generated = callPackage ./node-packages.nix { inherit self; };
      overrides = {
        "statsd" = { passthru.nodePackages = self; };
      };
    });
in self.statsd
