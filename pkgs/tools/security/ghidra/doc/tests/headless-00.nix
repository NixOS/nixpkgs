# Expected result:
# It should dump the headless analyzer usage information

let pkgs = import ./nixpkgs.nix; in

let
  inherit (pkgs) mkShell callPackage;

  ghidra = callPackage ./ghidra.nix {};
  newGh = self: super: {
    ghidra = super.ghidra.override {
      extraLaunchers = {
        "myGhidra" = self.lib.mkRunline {
           args = self.config.defaultOpts.args.headless;
           };
        };
      };
    }; 
in
  mkShell {
    name = "ghidra";
    buildInputs = [
      ((ghidra.extend newGh).withPlugins (p: with p; [ ghidra-scala-loader ]))
      ];
    shellHook = ''
      exec myGhidra
      '';
    }
