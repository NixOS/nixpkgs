{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, CoreServices
}:
rustPlatform.buildRustPackage rec {
  pname = "mdbook-footnote";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "daviddrysdale";
    repo = "mdbook-footnote";
    rev = "v${version}";
    hash = "sha256-WUMgm1hwsU9BeheLfb8Di0AfvVQ6j92kXxH2SyG3ses=";
  };

  cargoHash = "sha256-Ig+uVCO5oHIkkvFsKiBiUFzjUgH/Pydn4MVJHb2wKGc=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ CoreServices ];

  meta = with lib; {
    description = "Preprocessor for mdbook to support the inclusion of automatically numbered footnotes";
    mainProgram = "mdbook-footnote";
    homepage = "https://github.com/daviddrysdale/mdbook-footnote";
    license = licenses.asl20;
    maintainers = with maintainers; [ brianmcgillion matthiasbeyer ];
  };
}
