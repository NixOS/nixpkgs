{
  fetchFromGitea,
  rustPlatform,
}:
rec {
  version = "2.94.2";

  src = fetchFromGitea {
    domain = "git.lix.systems";
    owner = "lix-project";
    repo = "lix";
    rev = version;
    hash = "sha256-Nmqsl/YCnBW5U3TUfFWHGVUbyS2/Ll655BAE3qZilC4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "lix-${version}";
    inherit src;
    hash = "sha256-APm8m6SVEAO17BBCka13u85/87Bj+LePP7Y3zHA3Mpg=";
  };
}
