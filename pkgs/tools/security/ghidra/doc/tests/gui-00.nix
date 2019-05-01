# Expected result:
# A running Ghidra GUI instance

let pkgs = import ./nixpkgs.nix; in

let
  inherit (pkgs) mkShell callPackage;

  ghidra = callPackage ./ghidra.nix {};
in
  mkShell {
    name = "ghidra";
    buildInputs = [ ghidra ];
    shellHook = ''
      exec ghidraRun
      '';
    }
