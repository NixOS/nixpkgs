{ lib
, fetchFromGitHub
, crystal
}:

let
  generic =
    { version, hash }:

    crystal.buildCrystalPackage {
      pname = "shards";
      inherit version;

      src = fetchFromGitHub {
        owner = "crystal-lang";
        repo = "shards";
        rev = "v${version}";
        inherit hash;
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
  shards_0_17 = generic {
    version = "0.17.1";
    hash = "sha256-YAsFsMoZVUINnIQzYNjE7/hpvipmyU5DrLJJrk9TkHs=";
  };

  shards = shards_0_17;
}
