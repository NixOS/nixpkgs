{pkgs}:
let
  ghidra = pkgs.callPackage ./default.nix {};
in
{
  inherit ghidra;
  ghidraDev = (import ./eclipse.nix) (ghidra + "/lib/ghidra/Extensions/Eclipse/GhidraDev/GhidraDev-2.0.0.zip");
}
