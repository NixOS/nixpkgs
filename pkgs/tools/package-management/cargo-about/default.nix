{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-about";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "EmbarkStudios";
    repo = "cargo-about";
    rev = version;
    sha256 = "sha256-QLPqvlMwCdMfUGCVibCGQdI7UkHV1WBfpBi2Kwi3b1Q=";
  };

  cargoSha256 = "sha256-x9hx9wJlcrGo1zuugPYY4G4Os5x8tIOICKnKq8TuevI=";

  meta = with lib; {
    description = "Cargo plugin to generate list of all licenses for a crate";
    homepage = "https://github.com/EmbarkStudios/cargo-about";
    changelog =
      "https://github.com/EmbarkStudios/cargo-about/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      mit # or
      asl20
    ];
    maintainers = with maintainers; [ evanjs figsoda ];
  };
}
