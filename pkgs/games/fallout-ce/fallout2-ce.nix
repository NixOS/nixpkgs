{ callPackage
, fetchFromGitHub
, zlib
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

  extraBuildInputs = [ zlib ];

  extraMeta = {
    description = "Fully working re-implementation of Fallout 2, with the same original gameplay, engine bugfixes, and some quality of life improvements";
    homepage = "https://github.com/alexbatalov/fallout2-ce";
  };
}
