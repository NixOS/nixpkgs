{
  callPackage,
  fetchFromGitHub,
  fetchpatch2,
  zlib,
}:

callPackage ./build.nix rec {
  pname = "fallout2-ce";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout2-ce";
    rev = "v${version}";
    hash = "sha256-r1pnmyuo3uw2R0x9vGScSHIVNA6t+txxABzgHkUEY5U=";
  };

  patches = [
    # Fix case-sensitive filesystems issue when save/load games
    (fetchpatch2 {
      url = "https://github.com/alexbatalov/fallout2-ce/commit/d843a662b3ceaf01ac363e9abb4bfceb8b805c36.patch";
      sha256 = "sha256-r4sfl1JolWRNd2xcf4BMCxZw3tbN21UJW4TdyIbQzgs=";
    })
  ];

  extraBuildInputs = [ zlib ];

  extraMeta = {
    description = "Fully working re-implementation of Fallout 2, with the same original gameplay, engine bugfixes, and some quality of life improvements";
    homepage = "https://github.com/alexbatalov/fallout2-ce";
  };
}
