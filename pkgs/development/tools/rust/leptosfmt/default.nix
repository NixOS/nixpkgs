{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "leptosfmt";
  version = "0.1.16";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    rev = version;
    hash = "sha256-VzKwBqVoGa3bF6NK7mGOBEzUk9H+ZVQ/NdE/hhCEhUg=";
  };

  cargoHash = "sha256-OHAK1UX2mSBASUHT4qhGmWUdCrvP18RmXMCSnGSUBAA=";

  meta = with lib; {
    description = "A formatter for the leptos view! macro";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
