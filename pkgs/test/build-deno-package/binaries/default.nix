{ pkgs, buildDenoPackage }:
{
  linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-${targetSystem}";
    version = "0.1.0";
    denoDepsHash = "sha256-i+FKvKe1A38XBTk0YSuKshBpPXdAx+adWlXSCcmCJo8=";
    src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
    binaryEntrypointPath = "./main.ts";
    targetSystem = "x86_64-linux";
  };
  # mac =
  # let
  #   targetSystem = "aarch64-darwin";
  #  macpkgs = import ../../../../default.nix  { crossSystem = { config = "arm64-apple-darwin"; };};
  # in
  # buildDenoPackage {
  #   pname = "test-deno-build-binaries-${targetSystem}";
  #   version = "0.1.0";
  #   denoDepsHash = "";
  #   src = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
  #   binaryEntrypointPath = "./main.ts";
  #   denortPackage = macpkgs.denort;
  #   inherit targetSystem;
  # };
}
