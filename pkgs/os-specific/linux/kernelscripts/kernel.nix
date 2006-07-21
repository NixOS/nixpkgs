rec {
  inherit (import /nixpkgs/trunk/pkgs/top-level/all-packages.nix {})
    stdenv kernel ov511;

  everything = [kernel ov511];
}
