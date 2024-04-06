{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-epub";
  version = "0.4.37";

  src = fetchFromGitHub {
    owner = "michael-f-bryan";
    repo = "mdbook-epub";
    rev = "refs/tags/${version}";
    hash = "sha256-ddWClkeGabvqteVUtuwy4pWZGnarrKrIbuPEe62m6es=";
  };

  cargoHash = "sha256-cJS9HgbnLYXkZrAyGNEeu6q+znH+7cj8CUGIbTCbB9Y=";

  buildInputs = lib.optionals stdenv.isDarwin [
    Security
  ];

  meta = with lib; {
    description = "mdbook backend for generating an e-book in the EPUB format";
    mainProgram = "mdbook-epub";
    homepage = "https://michael-f-bryan.github.io/mdbook-epub";
    license = licenses.mpl20;
    maintainers = with maintainers; [ yuu ];
  };
}
