# Expected result:
# Some trace output, the build, and then
#   Listening for transport dt_socket at address: 18001

let pkgs = import ./nixpkgs.nix; in

let
  inherit (pkgs) mkShell callPackage;

  ghidra = callPackage ./ghidra.nix {};

  newOpts = self: super: {
    tracing = true;
    config = super.pkgs.lib.recursiveUpdate super.config ({
      defaultOpts.debug = {
        enable = true;
        }; 
      });
    };
  newGh = self: super: {
    ghidra = super.ghidra.override {
      extraLaunchers = {
        "myGhidraDebug" = self.lib.mkRunline { debug = { suspend = true; }; };
        };
      };
    }; 
in
  mkShell {
    name = "ghidra";
    buildInputs = [
      (((ghidra.extend newOpts).extend newGh).withPlugins (p: with p; [ ghidra-scala-loader ]))
      ];
    shellHook = ''
      exec myGhidraDebug
      '';
    }
