{ nix-gitignore, buildDenoPackage }:
{
  with-npm-linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-with-npm-${targetSystem}";
    version = "0.1.0";
    denoDepsHash = "sha256-k2js/8XsxGVu83rGMJed457orraue8WUZF+JUMMfhVQ=";
    src = nix-gitignore.gitignoreSource [ ] ./with-npm;
    binaryEntrypointPath = "./main.ts";
    targetSystem = "x86_64-linux";
  };
  without-npm-linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-without-npm-${targetSystem}";
    version = "0.1.0";
    denoDepsHash = "sha256-keshKcgawVcuSGNYAIepUrRl7iqpp0ExRJag4aiV18c=";
    src = nix-gitignore.gitignoreSource [ ] ./without-npm;
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
  #   src = nix-gitignore.gitignoreSource [ ] ./.;
  #   binaryEntrypointPath = "./main.ts";
  #   denortPackage = macpkgs.denort;
  #   inherit targetSystem;
  # };
}
