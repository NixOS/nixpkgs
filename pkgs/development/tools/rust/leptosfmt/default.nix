{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "leptosfmt";
  version = "0.1.12";

  src = fetchFromGitHub {
    owner = "bram209";
    repo = "leptosfmt";
    rev = version;
    hash = "sha256-RR4gwmYna/mvUw5akQutWKaUCWzCjK512gynR9Pddd0=";
  };

  cargoHash = "sha256-6du44SfH0dT1gWVFluB3+AA3GUzwN7Sjh03rKhSRKCM=";

  meta = with lib; {
    description = "A formatter for the leptos view! macro";
    homepage = "https://github.com/bram209/leptosfmt";
    changelog = "https://github.com/bram209/leptosfmt/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ figsoda ];
  };
}
