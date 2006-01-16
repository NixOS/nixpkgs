rec {
  inherit (import /nixpkgs/trunk/pkgs/system/i686-linux.nix)
    stdenv kernel ov511;

  everything = [kernel ov511];
}
