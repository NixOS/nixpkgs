# Expected result:
# An Eclipse instance should start, with the GhidraDev
# plugin asking for consent to open ports

let pkgs = import ./nixpkgs.nix; in

let
  inherit (pkgs) mkShell callPackage eclipses;

  ghidra = callPackage ./ghidra.nix {};

  eclipse = eclipses.eclipseWithPlugins {
    eclipse = eclipses.eclipse-java;
    plugins = [ ghidra.pkgs.ghidraDev ];
    };
in
  mkShell {
    name = "ghidra";
    buildInputs = [ eclipse ];
    shellHook = ''
      exec eclipse -data "$(mktemp -d)"
      '';
    }
