{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  bzip2,
  CoreServices,
}:

let
  pname = "mdbook-epub";
  version = "0.4.37";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "michael-f-bryan";
    repo = pname;
    rev = version;
    hash = "sha256-ddWClkeGabvqteVUtuwy4pWZGnarrKrIbuPEe62m6es=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-3R81PJCOFc22QDHH2BqGB9jjvEcMc1axoySSJLJD3wI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      bzip2
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      CoreServices
    ];

  meta = with lib; {
    description = "mdbook backend for generating an e-book in the EPUB format";
    mainProgram = "mdbook-epub";
    homepage = "https://michael-f-bryan.github.io/mdbook-epub";
    license = licenses.mpl20;
    maintainers = with maintainers; [
      yuu
      matthiasbeyer
    ];
  };
}
