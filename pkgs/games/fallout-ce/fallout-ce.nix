{ callPackage
, fetchFromGitHub
}:

callPackage ./build.nix rec {
  pname = "fallout-ce";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "alexbatalov";
    repo = "fallout1-ce";
    rev = "v${version}";
    hash = "sha256-ZiBoF3SL00sN0QrD3fkWG9SAknumOvzRB1oQJff6ITA=";
  };

  extraMeta = {
    description = "A fully working re-implementation of Fallout, with the same original gameplay, engine bugfixes, and some quality of life improvements";
    homepage = "https://github.com/alexbatalov/fallout1-ce";
  };
}
