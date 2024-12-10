{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  CoreServices,
  graphviz,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-graphviz";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "dylanowen";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-FuAjuU4IXXuas+ubSuTMrZiYTGcZCuLTCSTJXtY2nlw=";
  };

  cargoHash = "sha256-d4s9wmjqMHjev1Y4nAobFnCc5NTdklXcs7XTRXFMEjU=";

  buildInputs = lib.optionals stdenv.isDarwin [ CoreServices ];

  nativeCheckInputs = [ graphviz ];

  meta = with lib; {
    description = "A preprocessor for mdbook, rendering Graphviz graphs to HTML at build time";
    mainProgram = "mdbook-graphviz";
    homepage = "https://github.com/dylanowen/mdbook-graphviz";
    changelog = "https://github.com/dylanowen/mdbook-graphviz/releases/tag/v${version}";
    license = [ licenses.mpl20 ];
    maintainers = with maintainers; [
      lovesegfault
      matthiasbeyer
    ];
  };
}
