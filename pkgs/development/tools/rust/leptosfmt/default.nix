{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "leptosfmt";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    rev = version;
    hash = "sha256-QitvZ0AkZcXmjv8EnewWjexQMVEHy/naUarBIrzHbBA=";
  };

  cargoHash = "sha256-Fjj4lgkdHeA/3ajNbF1vTf6/YzGvDUJsDmiXzkEpels=";

  meta = with lib; {
    description = "A formatter for the leptos view! macro";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
