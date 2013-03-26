{ nixpkgs, officialRelease }:

{
  nixos = import ./release.nix;
  nixpkgs =
    import <nixpkgs/pkgs/top-level/release.nix> {
      inherit nixpkgs officialRelease;
      # Only do Linux builds.
      supportedSystems = [ "x86_64-linux" "i686-linux" ];
    };
}
