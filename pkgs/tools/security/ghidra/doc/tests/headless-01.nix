# Expected result:
# INFO  HelloWorldScript.scala> Hello world, I'm written in Scala! (GhidraScript)

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
      exec myGhidra $(mktemp -d) TestProj -noanalysis -preScript HelloWorldScript.scala
      '';
    }
