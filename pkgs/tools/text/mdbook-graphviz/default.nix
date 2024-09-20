{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, graphviz }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QLgTUQWfGoUV7L+nZKyO7yBYFi8/puikWkmDHQihc50=";
  };

  cargoHash = "sha256-cMCNZ8Ezp7bFx4EnuZCXhqoaE0yN3iK9KnCYBYGPHKc=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  nativeCheckInputs = [ graphviz ];

  meta = with lib; {
    description = "Preprocessor for mdbook, rendering Graphviz graphs to HTML at build time";
    mainProgram = "mdbook-graphviz";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    changelog = "https://github.com/dylanowen/mdbook-graphviz/releases/tag/v${version}";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [ lovesegfault matthiasbeyer ];
  };
}
