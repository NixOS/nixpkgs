{
  fetchFromGitea,
  rustPlatform,
}:
rec {
  version = "2.95.3";

  src = fetchFromGitea {
    domain = "git.lix.systems";
    owner = "lix-project";
    repo = "lix";
    rev = version;
    hash = "sha256-rEhhsqccghnnJHjsqCCBzdD7PyF/ibDe8zadnajBmjI=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    name = "lix-${version}";
    inherit src;
    hash = "sha256-a5XtutX+NS4wOqxeqbscWZMs99teKick5+cQfbCRGxQ=";
  };
}
