{ nix-gitignore, buildDenoPackage }:
{
  just-jsr-linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-just-jsr-${targetSystem}";
    version = "0.1.0";
    src = nix-gitignore.gitignoreSource [ ] ./just-jsr;
    binaryEntrypointPath = "./main.ts";
    denoDepsHash = "sha256-KKJxjrvgmtohU4nZc6JOLlRkOAEFLZV5ZS02AtEf8n8=";
    targetSystem = "x86_64-linux";
  };
  with-https-linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-with-https-${targetSystem}";
    version = "0.1.0";
    denoDepsHash = "sha256-LHVhHbMRiCp5HlJIjKYiBwiRqgrTc2+37c5SimM2up8=";
    src = nix-gitignore.gitignoreSource [ ] ./with-https;
    denoCompileFlags = [ "--allow-import=unpkg.com:443,jsr.io:443,deno.land:443,esm.sh:443" ];
    binaryEntrypointPath = "./main.ts";
    targetSystem = "x86_64-linux";
  };
  with-https-and-npm-linux = buildDenoPackage rec {
    pname = "test-deno-build-binaries-with-https-and-npm-${targetSystem}";
    version = "0.1.0";
    denoDepsHash = "sha256-l3uKWyVNCGNd/yJXTInbaVIsWqfaqh6NKroKkUubcaQ=";
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
