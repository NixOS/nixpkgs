{ lib
, fetchFromGitHub
, crystal_0_34
, crystal_0_36
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
  # needed for anything that requires the old v1 shards format
  shards_0_11 = generic {
    version = "0.11.1";
    sha256 = "05qnhc23xbmicdl4fwyxfpcvd8jq4inzh6v7jsjjw4n76vzb1f71";
    crystal = crystal_0_34;
  };

  shards_0_14 = generic {
    version = "0.14.1";
    sha256 = "sha256-/C6whh5RbTBkFWqpn0GqyVe0opbrklm8xPv5MIG99VU=";
    crystal = crystal_0_36;
  };

  shards = shards_0_14;
}
