# Expected result:
# A Ghidra GUI instance should start with the scala loader plugin listed under 
#  File -> Install Extensions

let pkgs = import ./nixpkgs.nix; in

let
  inherit (pkgs) mkShell callPackage;

  ghidra = callPackage ./ghidra.nix {};
in
  mkShell {
    name = "ghidra";
    buildInputs = [ (ghidra.withPlugins (p: with p; [ ghidra-scala-loader ])) ];
    shellHook = ''
      exec ghidraRun
      '';
    }
