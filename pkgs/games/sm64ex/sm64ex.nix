{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix {
  pname = "sm64ex";
  version = "0.pre+date=2021-11-30";

  src = fetchFromGitHub {
    owner = "sm64pc";
    repo = "sm64ex";
    rev = "db9a6345baa5acb41f9d77c480510442cab26025";
    sha256 = "sha256-q7JWDvNeNrDpcKVtIGqB1k7I0FveYwrfqu7ZZK7T8F8=";
  };

  extraMeta = {
    homepage = "https://github.com/sm64pc/sm64ex";
    description = "Super Mario 64 port based off of decompilation";
  };
}

