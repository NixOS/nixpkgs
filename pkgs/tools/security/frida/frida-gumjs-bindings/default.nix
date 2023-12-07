{ lib, fetchNpmDeps }:

fetchNpmDeps {
  src = lib.cleanSourceWith {
    filter = name: type: type == "directory" || !lib.hasSuffix ".nix" (baseNameOf name);
    src = lib.cleanSource ./.;
  };
  hash = "sha256-4/1whI8/3OYvla3wFDogBMm4bXVgrmnkdPmFh/ZPcw4=";
}
