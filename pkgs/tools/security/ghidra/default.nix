{pkgs}:
let
  ghidra = pkgs.callPackage ./ghidra.nix {};
  ghidraDev = import ./eclipse.nix (ghidra + "/lib/ghidra/Extensions/Eclipse/GhidraDev/GhidraDev-2.0.0.zip");
in ghidra // {
  passthru = {
    inherit ghidraDev;
  };
}
