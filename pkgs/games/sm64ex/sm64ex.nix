{ callPackage
, fetchFromGitHub
}:

callPackage ./generic.nix {
  pname = "sm64ex";
  version = "unstable-2023-07-01";

  src = fetchFromGitHub {
    owner = "sm64pc";
    repo = "sm64ex";
    rev = "54cd27ccee45a2403b45f07a00d6043c51149969";
    sha256 = "sha256-inKwdZR4v+tLmfY+rU+fIUdmGX3jCSBMMBqNcdfXHko=";
  };

  extraMeta = {
    homepage = "https://github.com/sm64pc/sm64ex";
    description = "Super Mario 64 port based off of decompilation";
  };
}

