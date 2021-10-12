{ lib
, fetchFromGitHub
, crystal_1_0
}:
let
  generic =
    { version, sha256, crystal }:

    crystal.buildCrystalPackage {
      pname = "shards";
      inherit version;

      src = fetchFromGitHub {
        owner = "crystal-lang";
        repo = "shards";
        rev = "v${version}";
        inherit sha256;
      };

      # we cannot use `make` or `shards` here as it would introduce a cyclical dependency
      format = "crystal";
      shardsFile = ./shards.nix;
      crystalBinaries.shards.src = "./src/shards.cr";

      # tries to execute git which fails spectacularly
      doCheck = false;

      meta = with lib; {
        description = "Dependency manager for the Crystal language";
        license = licenses.asl20;
        maintainers = with maintainers; [ peterhoeg ];
        inherit (crystal.meta) homepage platforms;
      };
    };

in
rec {

  shards_0_15 = generic {
    version = "0.15.0";
    sha256 = "sha256-/C6whh5RbTBkFWqpn0GqyVe0opbrklm8xPv5MIG99VU=";
    crystal = crystal_1_0;
  };

  shards = shards_0_15;
}
