{pkgs}:
let
  ghidra = pkgs.callPackage ./ghidra.nix {};
in
  ghidra // {
    passthru = {
      ghidraDev = (import ./eclipse.nix) (ghidra + "/lib/ghidra/Extensions/Eclipse/GhidraDev/GhidraDev-2.0.0.zip");
      };
    }
