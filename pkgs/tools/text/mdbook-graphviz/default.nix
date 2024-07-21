{ lib, stdenv, fetchFromGitHub, rustPlatform, CoreServices, graphviz }:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-myASia/nkZmAf00lZ357Sh3YV73pCBrZAIRhSzFkZa0=";
  };

  cargoHash = "sha256-UB/l+rcVHkrHv/fybDy/UjrJbVksWgt9JRQC118/kGM=";

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
