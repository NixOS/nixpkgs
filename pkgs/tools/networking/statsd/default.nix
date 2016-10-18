{ recurseIntoAttrs, callPackage, nodejs
}:

let
  self = recurseIntoAttrs (
    callPackage ../../../top-level/node-packages.nix {
      inherit nodejs self;
      generated = callPackage ./node-packages.nix { inherit self; };
      overrides = {
        "statsd" = { 
           passthru.nodePackages = self; 
           # statsd was built with nodejs 0.10 which reached end of LTS
           # in October 216, it doesn't built with nodejs 4.x
           meta.broken = true;
         };
      };
    });
in self.statsd
