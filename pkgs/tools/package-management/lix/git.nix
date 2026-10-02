{
  fetchFromGitea,
  rustPlatform,
}:
rec {
  version = "2.96.0-pre-20260408_${builtins.substring 0 12 src.rev}";

  src = fetchFromGitea {
    domain = "git.lix.systems";
    owner = "lix-project";
    repo = "lix";
    rev = "bc9fb560ac2d36cd317a856ee96785ea2055fbff";
    hash = "sha256-bONRPjhk5OZdnkQZexZNJzlvwIPg31Gy7fNiwGoX3BQ=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "lix-${version}";
    inherit src;
    hash = "sha256-a5XtutX+NS4wOqxeqbscWZMs99teKick5+cQfbCRGxQ=";
  };
}
