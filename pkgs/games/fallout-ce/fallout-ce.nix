{ callPackage
, fetchFromGitHub
}:

callPackage ./build.nix rec {
  pname = "fallout-ce";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout1-ce";
    rev = "v${version}";
    hash = "sha256-EvRkOlvtiVao63S0WRKKuHlhfkdTgc0m6GTyv4EfJFU=";
  };

  extraMeta = {
    description = "A fully working re-implementation of Fallout, with the same original gameplay, engine bugfixes, and some quality of life improvements";
    homepage = "https://github.com/alexbatalov/fallout1-ce";
  };
}
