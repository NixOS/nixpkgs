{ nix-gitignore, buildDenoPackage }:
{
  just-jsr-linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-just-jsr-${targetSystem}";
    version = "0.1.0";
    src = nix-gitignore.gitignoreSource [ ] ./just-jsr;
    binaryEntrypointPath = "./main.ts";
    denoDepsHash = "sha256-409W3v0E+wlFTiCXDUc5fJUwCzrmNaUKoqfRQReah3E=";
    targetSystem = "x86_64-linux";
  };
  with-https-linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-with-https-${targetSystem}";
    version = "0.1.0";
    denoDepsHash = "sha256-WtLL5X89y5xNwUniL5KBZtTvfzh3MYMywyCGH1Vw7hY=";
    src = nix-gitignore.gitignoreSource [ ] ./with-https;
    denoCompileFlags = [ "--allow-import=unpkg.com:443,jsr.io:443,deno.land:443,esm.sh:443" ];
    binaryEntrypointPath = "./main.ts";
    targetSystem = "x86_64-linux";
  };
  with-https-and-npm-linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-with-https-and-npm-${targetSystem}";
    version = "0.1.0";
    denoDepsHash = "sha256-rfSyyZBT7ZYSuRRxHhZz3OctQ21fCuUDPznXVGnw4nQ=";
    src = nix-gitignore.gitignoreSource [ ] ./with-https-and-npm;
    denoCompileFlags = [ "--allow-import=unpkg.com:443,jsr.io:443,deno.land:443,esm.sh:443" ];
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
