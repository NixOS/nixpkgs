{ lib, stdenv, fetchFromGitHub, fetchpatch, rustPlatform, CoreServices, graphviz }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.1.6";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WkjkQll5oETVADYpA8/CIZOJCBnfenGSy49sZ5nAQ+c=";
  };

  cargoHash = "sha256-whBTPQGozPPTSdXuRx5wamc1yy/EC3wNShQGhRqdY9Y=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  nativeCheckInputs = [ graphviz ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering Graphviz graphs to HTML at build time.";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    changelog = "https://github.com/dylanowen/mdbook-graphviz/releases/tag/v${version}";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ lovesegfault ];
  };
}
