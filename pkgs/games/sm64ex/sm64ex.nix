{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix {
  pname = "sm64ex";
  version = "unstable-2022-12-19";

  src = fetchFromGitHub {
    owner = "sm64pc";
    repo = "sm64ex";
    rev = "afc7e8da695bdf1aea5400a0d5c8b188d16a2088";
    sha256 = "sha256-TbA9yGPtP2uGsxN3eFaQwFeNjAjZ5hSk8Qmx1pRQxf8=";
  };

  extraMeta = {
    homepage = "https://github.com/sm64pc/sm64ex";
    description = "Super Mario 64 port based off of decompilation";
  };
}

