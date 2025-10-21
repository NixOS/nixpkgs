{
  lib,
  stdenvNoCC,
  fetch-deno-deps-scripts,
  deno,
  diff-so-fancy,
  static-web-server,
}:
let
  denoJson = builtins.fromJSON (builtins.readFile ./deno.json);
in
{
  fetchDenoDeps-integration-tests = stdenvNoCC.mkDerivation {
    pname = denoJson.name;
    inherit (denoJson) version;
    DENO_DIR = "./.deno";
    src = lib.fileset.toSource {
      root = ./.;
      fileset = lib.fileset.unions [
        ./src
        ./deno.json
      ];
    };
    buildPhase = ''
      deno test --allow-all ./src/lockfileTransformer.test.ts -- lockfile-transformer
      deno test --allow-all ./src/fetcher.test.ts -- single-fod-fetcher
      deno test --allow-all ./src/fileStructureTransformerNpm.test.ts -- file-structure-transformer-npm
      deno test --allow-all ./src/fileStructureTransformerVendor.test.ts -- file-structure-transformer-vendor
      touch $out
    '';
    nativeBuildInputs = [
      deno
      fetch-deno-deps-scripts.deno
      fetch-deno-deps-scripts.rust
      diff-so-fancy
      static-web-server
    ];
  };
}
