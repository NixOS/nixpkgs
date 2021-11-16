{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-Am0VwF37fYsZvUogxnSlP/kwy20J7maFu3Is8f/1b1E=";
  };

  cargoSha256 = "sha256-gf5OtRGjXmGbnXA4ZYOys6JU+JkF+rYnRSnjy3JE7c0=";

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog = "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ evanjs figsoda ];
  };
}
